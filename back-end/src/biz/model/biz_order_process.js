/**
*订单流程
*/
'use strict';
module.exports = class extends think.Model {

  async addData(param){
    param.create_date=think.datetime();
    param.del_flag=0;
    param.id=think.uuid('v1');
    await this.add(param);
  }

  async delData(param){
    await this.where({id:param.id}).delete();
  }

  async delFlagData(param){
    let id=param.id;
    await this.where({id:id}).update({update_date:think.datetime(),del_flag:1});
  }

  async delFlagDataByOrderId(orderId){
      await this.where({order_id:orderId}).update({update_date:think.datetime(),del_flag:1});
  }
  async updateData(param){
    let id=param.id;
    param.update_date=think.datetime();
    delete param.id;
    delete param.create_date;
    await this.where({id:id}).update(param);
  }

  async pageData(param){
    let sql=this.alias('a').join({
        table: 'sys_user',
        join: 'left',
        as: 'b',
        on: ['user_id', 'id']
    }).join({
        table: 'biz_order',
        as: 'c',
        on: ['order_id', 'id']
    }).field("a.*,b.name as user_name,c.order_no as o_order_no,c.name as o_name,c.invoice_date as o_invoice_date,"+
        "c.pro_num as o_pro_num,c.pro_price as o_pro_price"
    ).page(param.current).where({'a.del_flag':0}).order('a.create_date desc');
    if(!think.isEmpty(param.plan_date)){
      sql=sql.where({'a.plan_date':['like', '%'+param.plan_date+'%']});
    }
    if(!think.isEmpty(param.status)){
      sql=sql.where({'a.status':['like', '%'+param.status+'%']});
    }
    if(!think.isEmpty(param.process_status)){
        sql=sql.where({'a.process_status':['like', '%'+param.process_status+'%']});
    }
    let data = await sql.countSelect();
    return data;
  }

  async allData(param){
    let data=await this.where({del_flag:0}).select();
    return data;
  }

  async getData(id){
    return await this.where({id: id,del_flag:0}).find();
  }
};