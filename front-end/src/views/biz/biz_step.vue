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
                        业务环节列表
                    </p>
                    <Row>
                        环节名称：<Input v-model="searchForm.name" placeholder="请输入要搜索的环节名称" style="width: 200px;margin-right: 20px;" />
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


         <Modal  title="编辑"  :mask-closable="false" :closable="false" v-model="modalAdd" width="800">
            <Form ref="formRef" :model="formValidate" :rules="ruleValidate" :label-width="80">
                <FormItem label="订单环节" prop="order_step">
                    <Select style="width:200px" v-model="formValidate.order_step">
                        <Option v-for="item in order_step_dict"   :value="item.value" :key="item.value" >{{ item.label }}</Option>
                    </Select>
                </FormItem>
                <FormItem label="环节名称" prop="name">
                    <Input v-model="formValidate.name"></Input>
                </FormItem>

                <FormItem label="表单定义"><!-- prop="form_config"-->
                    <div class="edittable-table-height-con">
                        <my-edit-table refs="table2" v-model="form_config_data" :columns-list="editInlineColumns"></my-edit-table>
                    </div>
                </FormItem>
                <FormItem label="排序" prop="sort_no">
                    <Input v-model="formValidate.sort_no"></Input>
                </FormItem>
                <FormItem label="备注信息" prop="remarks">
                    <Input v-model="formValidate.remarks"></Input>
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
        <Modal  title="详情" v-model="modalDetail"  width="800" >
            <Form :model="formValidate" :label-width="80">
                <FormItem label="订单环节">
                    <Input  :value="convertDict('order_step',formValidate.order_step)"  readonly></Input>
                </FormItem>
                <FormItem label="环节名称">
                    <Input v-model="formValidate.name" readonly></Input>
                </FormItem>
                <FormItem label="表单定义">
                    <div class="edittable-table-height-con">
                        <my-edit-table  readMode="true" v-model="form_config_data" :columns-list="readInlineColumns"></my-edit-table>
                    </div>
                    <!--<Input v-model="formValidate.form_config" readonly></Input>-->
                </FormItem>
                <FormItem label="排序">
                    <Input v-model="formValidate.sort_no" readonly></Input>
                </FormItem>
                <FormItem label="备注信息">
                    <Input v-model="formValidate.remarks" readonly></Input>
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

    import myEditTable from '@/views/my/my-edit-table.vue';
    import util from '@/libs/util.js';

    export default {
        components: {
            myEditTable
        },
        data () {
            return{
                readInlineColumns:[
                    {
                        title: '序号',
                        type: 'index',
                        width: 60,
                        align: 'center'
                    },
                    {
                        title: '名称',
                        align: 'center',
                        key: 'name',
                        width: 180,
                        editable: true
                    },
                    {
                        title: '属性',
                        align: 'center',
                        key: 'key',
                        width: 180,
                        editable: true
                    },
                    {
                        title: '类型',
                        align: 'center',
                        key: 'type',
                        width: 180,
                        editable: true,
                        select_cfg: 'field_type'
                    }
                ],
                editInlineColumns: [
                    {
                        title: '序号',
                        type: 'index',
                        width: 60,
                        align: 'center'
                    },
                    {
                        title: '名称',
                        align: 'center',
                        key: 'name',
                        width: 120,
                        editable: true
                    },
                    {
                        title: '属性',
                        align: 'center',
                        key: 'key',
                        width: 120,
                        editable: true
                    },
                    {
                        title: '类型',
                        align: 'center',
                        key: 'type',
                        width: 120,
                        editable: true,
                        select_cfg: 'field_type'
                    },
                    {
                        title: '操作',
                        align: 'center',
                        width: 220,
                        key: 'handle',
                        handle: ['edit', 'delete']
                    }
                ],
                form_config_data:[],
                modalAdd:false,
                modalDetail:false,
                loading:false,
                modalLoading:false,
                modalCanBut:true,
                status_dict:{},
                order_step_dict:{},
                field_type_dict:{},
                searchForm:{
                    current:1
                },
                data: [],
                formValidate: {
                },
                count:0,
                columns: [
                    {
                        title: '环节名称',
                        key: 'name',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    },
                    {
                        title: '订单环节',
                        key: 'order_step',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                        render: (h, params) => {
                            return  h('span', util.showDictLabel('order_step',params.row.order_step));
                        }
                    },
                    {
                        title: '创建时间',
                        key: 'create_date',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    },
                    {
                        title: '备注信息',
                        key: 'remarks',
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
                    order_step: [
                        { required: true, message: '订单流程环节为必填项'}
                    ],
                    name: [
                        { required: true, message: '环节名称为必填项'}
                    ],
                    form_config: [
                        { required: true, message: '表单定义为必填项'}
                    ],
                    sort_no: [
                        { required: true, message: '排序为必填项'}
                    ],
                    remarks: [
                        { required: true, message: '备注信息为必填项'}
                    ],
                    status: [
                        { required: true, message: '状态为必填项'}
                    ],
                }
            }
        },
        methods: {
            init () {
                let _self=this;
                _self.loading=true;
                util.post(this,'biz/biz_step/pageData',this.searchForm,function(datas){
                    _self.data=datas.data;
                    _self.count=datas.count;
                    _self.loading=false;
                });
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
                this.formValidate={};
                this.form_config_data=[];
                this.modalAdd=true;
            },
            show (param) {
                this.formValidate=util.copy(param.row);
                this.form_config_data = this.formValidate.form_config ? JSON.parse(this.formValidate.form_config) : [];
                this.modalDetail=true;
             },
            edit (param) {
                this.formValidate=util.copy(param.row);
                this.form_config_data = this.formValidate.form_config ? JSON.parse(this.formValidate.form_config) : [];
                this.modalAdd=true;
             },
            remove (param) {
                let _self=this;
                this.loading=true;
                util.post(this,'biz/biz_step/delData',{id:param.row.id},function(datas){
                    _self.data.splice(param.index, 1);
                    _self.loading =false;
                    _self.$Message.success('删除成功！');
                });
            },
            addOkFun(){
                let _self=this;

                this.formValidate.form_config= JSON.stringify( this.form_config_data.filter(item => {
                    if (Object.keys(item).length > 0) {
                        return item;
                    }
                }));

                this.$refs['formRef'].validate((valid) => {
                    if (valid) {
                        util.changeModalLoading(this,true);
                        let _data=util.copy(this.formValidate);
                        if(this.formValidate&&this.formValidate.id){
                            util.post(this,'biz/biz_step/updateData',_data,function(datas){
                                _self.$Message.success('编辑成功！');
                                _self.addCanFun();
                                _self.init();
                            });
                        }else{
                            util.post(this,'biz/biz_step/addData',_data,function(datas){
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
            this.order_step_dict=util.showDictList('order_step');
            this.field_type_dict=util.showDictList('field_type');
            this.init();
        }
    }
</script>
