/**
*属性
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

  async updateData(param){
    let id=param.id;
    param.update_date=think.datetime();
    delete param.id;
    delete param.create_date;
    await this.where({id:id}).update(param);
  }

  async pageData(param){
    let sql=this.page(param.current).where({del_flag:0,attribute_category_id:param.pid}).order('sort_order');
    if(!think.isEmpty(param.name)){
      sql=sql.where({name:['like', '%'+param.name+'%']});
    }
    let data = await sql.countSelect();
    return data;
  }

  async findListByPid(param){
    let data=await this.where({del_flag:0,attribute_category_id:param.pid}).select();
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