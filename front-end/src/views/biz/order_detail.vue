<template>
    <Tabs type="card">
        <TabPane label="标签一">
            <Form ref="formRef" :model="formValidate" :rules="ruleValidate" :label-width="80">
                <FormItem label="完成时间" prop="finish_date">
                    <Input v-model="formValidate.finish_date"></Input>
                </FormItem>
                <FormItem label="表单数据" prop="form_data">
                    <Input v-model="formValidate.form_data"></Input>
                </FormItem>
                <FormItem label="订单id" prop="order_id">
                    <Input v-model="formValidate.order_id"></Input>
                </FormItem>
                <FormItem label="预计时间" prop="plan_date">
                    <Input v-model="formValidate.plan_date"></Input>
                </FormItem>
                <FormItem label="数量" prop="pro_num">
                    <Input v-model="formValidate.pro_num"></Input>
                </FormItem>
                <FormItem label="是否激活 0-否 1-是" prop="process_status">
                    <Input v-model="formValidate.process_status"></Input>
                </FormItem>
                <FormItem label="备注" prop="remarks">
                    <Input v-model="formValidate.remarks"></Input>
                </FormItem>
                <FormItem label="状态 0-待处理 1-处理中 2-完成 3-取消" prop="status">
                    <Input v-model="formValidate.status"></Input>
                </FormItem>
                <FormItem label="环节名称" prop="step_name">
                    <Input v-model="formValidate.step_name"></Input>
                </FormItem>
                <FormItem label="用户id" prop="user_id">
                    <Input v-model="formValidate.user_id"></Input>
                </FormItem>
            </Form>
            <div slot="footer">
                <!--<Button type="text" @click="addCanFun" v-show="modalCanBut">取消</Button>-->
                <!--<Button type="primary" @click="addOkFun" :loading="modalLoading">确定</Button>-->
            </div>

        </TabPane>
        <TabPane label="标签二">
            <Steps :current="2" direction="vertical">
                <Step title="已完成" content="这里是该步骤的描述信息"></Step>
                <Step title="已完成" content="这里是该步骤的描述信息"></Step>
                <Step title="进行中" content="这里是该步骤的描述信息"></Step>
                <Step title="待进行" content="这里是该步骤的描述信息"></Step>
            </Steps>
        </TabPane>
        <TabPane label="标签三">


        </TabPane>
    </Tabs>
</template>
<script>
    export default {
        name: "orderDetail",
        props:{
            order_id:{
                type:String,
                default:()=>{}
            }
        },
        data () {
            return {
                formValidate: {
                },
                ruleValidate: {
                    finish_date: [
                        { required: true, message: '完成时间为必填项'}
                    ],
                    form_data: [
                        { required: true, message: '表单数据为必填项'}
                    ],
                    order_id: [
                        { required: true, message: '订单id为必填项'}
                    ],
                    plan_date: [
                        { required: true, message: '预计时间为必填项'}
                    ],
                    pro_num: [
                        { required: true, message: '数量为必填项'}
                    ],
                    process_status: [
                        { required: true, message: '是否激活 0-否 1-是为必填项'}
                    ],
                    remarks: [
                        { required: true, message: '备注为必填项'}
                    ],
                    status: [
                        { required: true, message: '状态 0-待处理 1-处理中 2-完成 3-取消为必填项'}
                    ],
                    step_name: [
                        { required: true, message: '环节名称为必填项'}
                    ],
                    user_id: [
                        { required: true, message: '用户id为必填项'}
                    ],
                }
            }

        },
        methods: {
            init () {
                let _self=this;
                _self.loading=true;

            }
        },
        mounted () {
            this.init();
        }
    }
</script>
