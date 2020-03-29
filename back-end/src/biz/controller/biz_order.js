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

  async updateDataAction() {
    let param=this.post();
    await this.model('biz_order').updateData(param);
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