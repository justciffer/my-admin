<style lang="less">
    @import "./home.less";
    @import "../../styles/common.less";
</style>
<template>
    <div class="home-main">
        <Row :gutter="10">
            <Col :md="24" :lg="24">
                <Row class-name="home-page-row1" :gutter="10">
                    <Col :md="12" :lg="12" :style="{marginBottom: '10px'}">
                        <Card>
                            <Row type="flex" class="user-infor">
                                <Col span="8">
                                    <Row class-name="made-child-con-middle" type="flex" align="middle">
                                        <img class="avator-img" :src="avatorPath" />
                                    </Row>
                                </Col>
                                <Col span="16" style="padding-left:6px;">
                                    <Row class-name="made-child-con-middle" type="flex" align="middle">
                                        <div>
                                            <b class="card-user-infor-name">{{userName}}</b>
                                        </div>
                                    </Row>
                                </Col>
                            </Row>
                            <div class="line-gray"></div>
                            <Row class="margin-top-8">
                                <Col span="8"><p class="notwrap">上次登录时间:</p></Col>
                                <Col span="16" class="padding-left-8">{{last_login}}</Col>
                            </Row>
                        </Card>
                    </Col>
                </Row>
            </Col>
            <Col :md="24" :lg="24">
                <Row :gutter="5">
                    <Col :xs="24" :sm="12" :md="4" :style="{marginBottom: '10px'}">
                        <infor-card
                            id-name="user_created_count"
                            :end-val="count.orderNum"
                            iconType="android-person-add"
                            color="#2d8cf0"
                            intro-text="已完成订单数量"
                        ></infor-card>
                    </Col>
                    <Col :xs="24" :sm="12" :md="4" :style="{marginBottom: '10px'}">
                        <infor-card
                            id-name="visit_count"
                            :end-val="count.orderMoney"
                            iconType="ios-eye"
                            color="#64d572"
                            :iconSize="50"
                            intro-text="已完成订单总金额"
                        ></infor-card>
                    </Col>
                    <Col :xs="24" :sm="12" :md="4" :style="{marginBottom: '10px'}">
                        <infor-card
                            id-name="transfer_count"
                            :end-val="count.orderProNum"
                            iconType="shuffle"
                            color="#f25e43"
                            intro-text="已完成产品数量"
                        ></infor-card>
                    </Col>
                </Row>
            </Col>
        </Row>

    </div>
</template>

<script>
import inforCard from './components/inforCard.vue';

export default {
    name: 'home',
    components: {
        inforCard
    },
    data () {
        return {
            toDoList: [
                {
                    title: '去iView官网学习完整的iView组件'
                },
                {
                    title: '去iView官网学习完整的iView组件'
                },
                {
                    title: '去iView官网学习完整的iView组件'
                },
                {
                    title: '去iView官网学习完整的iView组件'
                },
                {
                    title: '去iView官网学习完整的iView组件'
                }
            ],
            count: {
                orderNum: 496,
                orderMoney: 3264,
                orderProNum: 24389305,
            },
            showAddNewTodo: false,
            newToDoItemValue: ''
        };
    },
    computed: {
        avatorPath () {
            return localStorage.avatorImgPath;
        },
        userName () {
            return localStorage.user_name;
        },
        last_login () {
            return localStorage.login_date;
        }
    },
    methods: {

    }
};
</script>
