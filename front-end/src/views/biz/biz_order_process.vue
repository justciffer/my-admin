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
                        订单流程列表
                    </p>
                    <Row>
                        预计时间：<Input v-model="searchForm.plan_date" placeholder="请输入要搜索的预计时间" style="width: 200px;margin-right: 20px;" />
                        状态：
                        <Select style="width:200px" v-model="searchForm.status" >
                            <Option v-for="item in status_dict"  :value="item.value" :key="item.value" >{{ item.label }}</Option>
                        </Select>
                        <span @click="handleSearch"><Button type="primary" icon="search">搜索</Button></span>
                    </Row>
                    <Row type="flex" justify="center" align="middle" class="advanced-router">
                        <Table border stripe :columns="columns" :data="data" :loading="loading" style="width: 100%;margin-top:10px"></Table>
                        <Page :total="count" :current="searchForm.current" show-total  style="margin-top:10px;" @on-change="pageChange"></Page>
                    </Row>
                </Card>
            </Col>
        </Row>
        <Modal  title="订单生产" :mask-closable="false" :closable="false" v-model="openDetail" scrollable width="850">
            <order-detail :order_id="detailId"></order-detail>
            <div slot="footer"  align="center">
                <Button  size="large" long @click="closeDetail">关闭</Button>
            </div>
        </Modal>
    </div>
</template>
<script>
    import util from '@/libs/util.js';
    import orderDetail from '@/views/biz/order_detail.vue';

    export default {
        components: {
            orderDetail
        },
        data () {
            return {
                detailId:'',
                openDetail:false,
                loading:false,
                status_dict:{},
                searchForm:{
                    current:1
                },
                data: [],
                count:0,
                columns: [
                    {
                        title: '订单编号',
                        key: 'o_order_no',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    },
                    {
                        title: '订单名称',
                        key: 'o_name',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    },
                    {
                        title: '环节名称',
                        key: 'step_name',
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
                        title: '预计时间',
                        key: 'plan_date',
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
                            return  h('span', util.showDictLabel('order_process_type',params.row.status));
                        }
                    },
                    {
                        title: '办理人',
                        key: 'user_name',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
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
                                }, '办理'),
                            ]);
                        }
                    }
                ]
            }
        },
        methods: {
            init () {
                let _self=this;
                _self.loading=true;
                this.searchForm.process_status='1';
                util.post(this,'biz/biz_order_process/pageData',this.searchForm,function(datas){
                    _self.data=datas.data;
                    _self.count=datas.count;
                    _self.loading=false;
                });
            },
            handleSearch(){
                this.searchForm.current=1;
                this.init();
            },
            pageChange(current){
                this.searchForm.current=current;
                this.init();
            },
            edit (param) {
                this.detailId=util.copy(param.row).order_id;
                this.openDetail=true;
             },
            closeDetail () {
                this.openDetail=false;
                this.init();
            },

        },
        mounted () {
            this.status_dict=util.showDictList('order_process_type');
            this.init();
        }
    }
</script>
