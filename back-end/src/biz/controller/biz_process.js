/**
*业务流程
*/
const Base = require('../../admin/controller/base.js');
module.exports = class extends Base {
  async indexAction() {
    return this.display();
  }

  async allDataAction() {
    let data=await this.model('biz_process').allData()
    return this.success(data);
  }


  async processDataAction() {
      let param=this.post();
      let data=await this.model('biz_process').getData(param.process_id);
      if(data && !think.isEmpty(data.step_config)){

        let _arr = JSON.parse(data.step_config);
        if(_arr && _arr.length > 0){
            data.step_list = await this.model('biz_step').getDataByIds(_arr);
        }
      }
      return this.success(data);
  }

  async pageDataAction() {
    let param=this.post();
    let data=await this.model('biz_process').pageData(param);
    return this.success(data);
  }

  async addDataAction() {
    let param=this.post();
    await this.model('biz_process').addData(param);
    return this.success();
  }

  async updateDataAction() {
    let param=this.post();
    await this.model('biz_process').updateData(param);
    return this.success();
  }

  async delDataAction() {
    let param=this.post();
    await this.model('biz_process').delData(param);
    return this.success();
  }
  async delFlagDataAction() {
    let param=this.post();
    await this.model('biz_process').delFlagData(param);
    return this.success();
  }
};