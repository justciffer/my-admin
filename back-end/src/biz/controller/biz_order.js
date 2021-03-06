/**
*业务订单
*/
const Base = require('../../admin/controller/base.js');
module.exports = class extends Base {
  async indexAction() {
    return this.display();
  }

  async allDataAction() {
    let data=await this.model('biz_order').allData()
    return this.success(data);
  }

  async pageDataAction() {
    let param=this.post();
    let data=await this.model('biz_order').pageData(param);
    return this.success(data);
  }

  async addDataAction() {
    let param=this.post();
    await this.model('biz_order').addData(param);
    return this.success();
  }

    async detailAction() {
        let param=this.post();
        let order = {};
        if(param.id){
            order = await this.model('biz_order').getData(param.id);
        }
        return this.success(order);
    }

    async processInfoAction() {
        let param=this.post();
        let processInfo = {};
        if(param.id){
            processInfo.order = await this.model('biz_order').getData(param.id);
            let orderProcessList = await this.model('biz_order_process').listInOrder(param.id);
            if(orderProcessList){
                orderProcessList.forEach(step=>{
                    let _form_config = JSON.parse(step.s_form_config);
                    let _form_data = JSON.parse(step.form_data);

                    if(!think.isEmpty(_form_data)){
                        _form_config.forEach(item=>{
                            item.value=_form_data[item.key];
                        });
                    }
                    step.items=_form_config;
                });
            }
            processInfo.list=orderProcessList;
        }

        return this.success(processInfo);
    }

  async updateDataAction() {
    let param=this.post();
    await this.model('biz_order').updateData(param);
    return this.success();
  }

    /**
     order_id
     process_id
     stepList
       id
       name
       itemList
         origin_key
         origin_name
         i_value
    */
  async startAction() {
      let param = this.post();
      let order = await this.model('biz_order').getData(param.order_id);
      
      if(!param.stepList && param.stepList.length == 0){
          return this.fail(600, "操作失败，数据有误");
      }
      //删除旧数据
      await this.model('biz_order_process').delFlagDataByOrderId(param.order_id);
      //生成订单流程数据

        /**
           id
           order_id
           user_id
           pro_num
           form_data
           plan_date
           finish_date
           create_date
           update_date
           remarks
           status	 状态 0-待处理 1-处理中 2-完成 3-取消
           del_flag
         */

        let first= true;
        let index=0;
        for(const  step of param.stepList) {
            let order_step_data={};
            order_step_data.order_id= param.order_id;
            // order_step_data.user_id= this.userInfo().id;
            order_step_data.step_id= step.id;
            order_step_data.status= '0';
            order_step_data.process_status= first? '1' : '0';
            order_step_data.process_id= param.process_id;
            order_step_data.sort_no= ++index ;

            first=false;
            let _data={};
            if(step.itemList && step.itemList.length > 0){
                step.itemList.forEach(item=>{
                    _data[item.origin_key]=item.i_value?item.i_value:null;
                });
            }
            order_step_data.form_data=JSON.stringify(_data);
            await this.model('biz_order_process').addData(order_step_data);
        }

      //设置生产中
      order.status = '1';
      await this.model('biz_order').updateData(order);

      return this.success();
  }

  async delDataAction() {
    let param=this.post();
    await this.model('biz_order').delData(param);
    return this.success();
  }
  async delFlagDataAction() {
    let param=this.post();
    await this.model('biz_order').delFlagData(param);
    return this.success();
  }
};
