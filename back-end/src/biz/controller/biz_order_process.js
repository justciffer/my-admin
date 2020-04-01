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