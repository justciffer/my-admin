/**
*订单流程
*/
const Base = require('../../admin/controller/base.js');
module.exports = class extends Base {
  async indexAction() {
    return this.display();
  }

  async allDataAction() {
    let data=await this.model('biz_order_process').allData()
    return this.success(data);
  }

  async detailAction() {
      let param=this.post();
      let data = {};
      if(param.id){
          data = await this.model('biz_order_process').getData(param.id);
      }
      return this.success(data);
  }
  async pageDataAction() {
    let param=this.post();
    let data=await this.model('biz_order_process').pageData(param);
    return this.success(data);
  }

  async addDataAction() {
    let param=this.post();
    await this.model('biz_order_process').addData(param);
    return this.success();
  }

  async updateDataAction() {
    let param=this.post();
    await this.model('biz_order_process').updateData(param);
    return this.success();
  }

  async doProcessAction() {
      let param=this.post();
      //op_type doAccept doSave doFinish doReject
      if(think.isEmpty(param.op_type)){
          return this.fail(600, "操作失败，数据有误");
      }
      switch(param.op_type){
          case 'doAccept':{
              param.user_id = this.userInfo().id;
              param.status = '1';
              await this.model('biz_order_process').updateData(param);
              //todo: 修改订单状态  status  增加订单流程状态
              break;
          }
          case 'doSave':{
              await this.model('biz_order_process').updateData(param);
              break;
          }
          case 'doFinish':{
              param.status = '2';
              param.finish_date=think.datetime();
              param.process_status='0';
              await this.model('biz_order_process').updateData(param);

              let next = await this.model('biz_order_process').getDataByParam(param.order_id,param.sort_no + 1);
              if(!think.isEmpty(next)){
                  next.status = '0';
                  next.process_status='1';
                  await this.model('biz_order_process').updateDataAsNew(next);
              }else{
                  //todo：流程完成

                  let order={};
                  order.id=param.order_id;
                  order.status='2';
                  order.finish_date=think.datetime();
                  await this.model('biz_order').updateData(order);
                  //todo: 修改订单状态  status  增加订单流程状态

              }
              //todo: 修改订单状态  status  增加订单流程状态
              break;
          }
          case 'doReject':{
              param.status = '3';
              param.process_status='0';
              await this.model('biz_order_process').updateData(param);

              let next = await this.model('biz_order_process').getDataByParam(param.order_id,param.sort_no - 1);
              if(!think.isEmpty(next)){
                  next.status = '0';
                  next.process_status='1';
                  await this.model('biz_order_process').updateData(next);
              }else{
                  return this.fail(600, "无法回退，已经是第一个节点");
              }
              //todo: 环节流转
              //todo: 修改订单状态  status  增加订单流程状态

              break;
          }
      }

      return this.success();
  }
  async delDataAction() {
    let param=this.post();
    await this.model('biz_order_process').delData(param);
    return this.success();
  }
  async delFlagDataAction() {
    let param=this.post();
    await this.model('biz_order_process').delFlagData(param);
    return this.success();
  }
};