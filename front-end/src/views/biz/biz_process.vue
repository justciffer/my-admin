<style lang="less">
     .table-min-width{
        min-width:120px;
        width:120px
    }
</style>
<template>
     <div>
        <Row>
            <Col span="24">
                <Card>
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        业务流程列表
                    </p>
                    <Row>
                        流程名称：<Input v-model="searchForm.name" placeholder="请输入要搜索的流程名称" style="width: 200px;margin-right: 20px;" />
                        <span @click="handleSearch"><Button type="primary" icon="search">搜索</Button></span>
                    </Row>
                    <Row style="margin-top:10px;">
                        <Button type="info" @click="add">添加</Button>
                    </Row>
                    <Row type="flex" justify="center" align="middle" class="advanced-router">
                        <Table border stripe :columns="columns" :data="data" :loading="loading" style="width: 100%;margin-top:10px"></Table>
                        <Page :total="count" :current="searchForm.current" show-total  style="margin-top:10px;" @on-change="pageChange"></Page>
                    </Row>
                </Card>
            </Col>
        </Row>
        <Modal  title="编辑"  :mask-closable="false" :closable="false" v-model="modalAdd" width="600">
            <Form ref="formRef" :model="formValidate" :rules="ruleValidate" :label-width="80">
                <FormItem label="流程名称" prop="name">
                    <Input v-model="formValidate.name"></Input>
                </FormItem>
                <!--todo: 修改选择方式  https://www.iviewui.com/components/transfer-->
                <FormItem label="环节定义"> <!-- prop="step_config" 去除校验-->
                    <Transfer
                            :data="stepList" :titles="['所有环节','选中环节']"
                            :target-keys="step_config_data"   :render-format="renderStep"   @on-change="handleChangeStep"  ></Transfer>
                </FormItem>
                <FormItem label="备注" prop="remark">
                    <Input v-model="formValidate.remark" type="textarea"></Input>
                </FormItem>
                <FormItem label="状态" prop="status">
                    <Select style="width:200px" v-model="formValidate.status" >
                        <Option v-for="item in status_dict"  :value="item.value" :key="item.value" >{{ item.label }}</Option>
                    </Select>
                </FormItem>
            </Form>
            <div slot="footer">
                <Button type="text" @click="addCanFun" v-show="modalCanBut">取消</Button>
                <Button type="primary" @click="addOkFun" :loading="modalLoading">确定</Button>
            </div>
        </Modal>
        <Modal  title="详情" v-model="modalDetail" width="600">
            <Form :model="formValidate" :label-width="80">
                <FormItem label="流程名称">
                    <Input v-model="formValidate.name" readonly></Input>
                </FormItem>
                <FormItem label="环节定义">
                    <Table height="200" border stripe  size="small" :columns="show_step_cols" :data="show_step_data"></Table>
                </FormItem>
                <FormItem label="备注" prop="remark">
                    <Input v-model="formValidate.remark" type="textarea" readonly></Input>
                </FormItem>
                <FormItem label="状态">
                    <Input  :value="convertDict('status_type',formValidate.status)"  readonly></Input>
                </FormItem>
            </Form>
            <div slot="footer">
            </div>
        </Modal>

    </div>
</template>
<script>
    import util from '@/libs/util.js';
    export default {
        data () {
            return {
                modalAdd:false,
                modalDetail:false,
                loading:false,
                modalLoading:false,
                modalCanBut:true,
                status_dict:{},
                stepList:[],
                show_step_data:[],
                show_step_cols:[
                    {
                        title: '顺序',
                        type: 'index',
                        width: 60,
                        align: 'center'
                    },
                    {
                        title: '环节名称',
                        key: 'label',
                        className: 'table-min-width',
                        ellipsis:true,
                        width: 150,
                        align: 'center',
                    },
                    {
                        title: '描述',
                        key: 'description',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    }],
                searchForm:{
                    current:1
                },
                data: [],
                formValidate: {
                },
                step_config_data:[],
                count:0,
                columns: [
                    {
                        title: '流程名称',
                        key: 'name',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    },
                    {
                        title: '创建时间',
                        key: 'create_date',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    },
                    {
                        title: '状态',
                        key: 'status',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                        render: (h, params) => {
                            return  h('span', util.showDictLabel('status_type',params.row.status));
                        }
                    },
                    {
                        title: '操作',
                        key: 'action',
                        width: 210,
                        align: 'center',
                        render: (h, params) => {
                            return h('div', [
                                h('Button', {
                                    props: {
                                        type: 'info',
                                        size: 'small'
                                    },
                                    style: {
                                        marginRight: '5px'
                                    },
                                    on: {
                                        click: () => {
                                            this.show(params)
                                        }
                                    }
                                }, '查看'),
                                h('Button', {
                                    props: {
                                        type: 'success',
                                        size: 'small'
                                    },
                                    style: {
                                        marginRight: '5px'
                                    },
                                    on: {
                                        click: () => {
                                            this.edit(params)
                                        }
                                    }
                                }, '编辑'),
                                h('Poptip', {
                                    props: {
                                        confirm: true,
                                        title: '您确定要删除这条数据吗?',
                                        transfer: true
                                    },
                                    on: {
                                        'on-ok': () => {
                                           this.remove(params);
                                        }
                                    }
                                }, [
                                    h('Button', {
                                        style: {
                                            marginRight: '5px'
                                        },
                                        props: {
                                            type: 'error',
                                            placement: 'top',
                                            size: 'small'
                                        }
                                    }, '删除')
                                ])
                            ]);
                        }
                    }
                ],
                ruleValidate: {
                    name: [
                        { required: true, message: '流程名称为必填项'}
                    ],
                    status: [
                        { required: true, message: '状态为必填项'}
                    ],
                    step_config: [
                        { required: true, message: '环节定义为必填项'}
                    ],
                }
            }
        },
        methods: {
            init () {
                let _self=this;
                _self.loading=true;
                util.post(this,'biz/biz_process/pageData',this.searchForm,function(datas){
                    _self.data=datas.data;
                    _self.count=datas.count;
                    _self.loading=false;
                });

            },
            renderStep (item) {
                return item.label ;//+ ' - ' + item.description;
            },
            handleChangeStep (newTargetKeys) {
                this.step_config_data = newTargetKeys;
            },
            convertDict(type,value){
                return util.showDictLabel(type,value);
            },
            handleSearch(){
                this.searchForm.current=1;
                this.init();
            },
            pageChange(current){
                this.searchForm.current=current;
                this.init();
            },
            add (){
                this.formValidate={status:'1'};
                this.step_config_data = [];
                this.modalAdd=true;
            },
            show (param) {
                this.formValidate=util.copy(param.row);
                this.show_step_data = [];
                let _data = this.formValidate.step_config ? JSON.parse(this.formValidate.step_config) : [];
                _data.forEach(item =>{
                    this.stepList.forEach(_step =>{
                        if(_step.key == item){
                            this.show_step_data.push(_step);
                        }
                    });
                });


                this.modalDetail=true;
             },
            edit (param) {
                this.formValidate=util.copy(param.row);
                this.step_config_data = this.formValidate.step_config ? JSON.parse(this.formValidate.step_config) : [];
                this.modalAdd=true;
             },
            remove (param) {
                let _self=this;
                this.loading=true;
                util.post(this,'biz/biz_process/delData',{id:param.row.id},function(datas){
                    _self.data.splice(param.index, 1);
                    _self.loading =false;
                    _self.$Message.success('删除成功！');
                });
            },
            addOkFun(){
                let _self=this;
                this.formValidate.step_config = JSON.stringify( this.step_config_data);

                this.$refs['formRef'].validate((valid) => {
                    if (valid) {
                        util.changeModalLoading(this,true);
                        let _data=util.copy(this.formValidate);
                        if(this.formValidate&&this.formValidate.id){
                            util.post(this,'biz/biz_process/updateData',_data,function(datas){
                                _self.$Message.success('编辑成功！');
                                _self.addCanFun();
                                _self.init();
                            });
                        }else{
                            util.post(this,'biz/biz_process/addData',_data,function(datas){
                                _self.$Message.success('新增成功！');
                                _self.addCanFun();
                                _self.init();
                            });
                        }
                    }else{
                        util.changeModalLoading(this);
                    }
                })
            },
            addCanFun(){
                this.modalAdd=false;
                util.changeModalLoading(this);
                this.$refs['formRef'].resetFields();
            }
        },
        mounted () {
            this.status_dict=util.showDictList('status_type');
            let _self = this;
            util.post(this,'biz/biz_step/allData',{},function(datas){
                datas.forEach(item=>{
                    _self.stepList.push({key:item.id,label:item.name,description:item.remarks});
                });
            });
            this.init();
        }
    }
</script>
