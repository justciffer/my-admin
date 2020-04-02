<style lang="less">
    @import './editable-table.less';
</style>

<template>
    <div>
        <Table :ref="refs" :columns="columnsList" :data="thisTableData" border disabled-hover></Table>
    </div>
</template>

<script>
    import util from '@/libs/util.js';

    const editButton = (vm, h, currentRow, index) => {
    return h('Button', {
        props: {
            type: currentRow.editting ? 'success' : 'primary',
            loading: currentRow.saving,
            size: 'small'
        },
        style: {
            margin: '0 5px'
        },
        on: {
            'click': () => {
                if (!currentRow.editting) {
                    if (currentRow.edittingCell) {
                        for (let name in currentRow.edittingCell) {
                            currentRow.edittingCell[name] = false;
                            vm.edittingStore[index].edittingCell[name] = false;
                        }
                    }
                    vm.edittingStore[index].editting = true;
                    vm.thisTableData = JSON.parse(JSON.stringify(vm.edittingStore));
                } else {
                    vm.edittingStore[index].saving = true;
                    vm.thisTableData = JSON.parse(JSON.stringify(vm.edittingStore));
                    let edittingRow = vm.edittingStore[index];
                    edittingRow.editting = false;
                    edittingRow.saving = false;
                    vm.thisTableData = JSON.parse(JSON.stringify(vm.edittingStore));
                    vm.$emit('input', vm.handleBackdata(vm.thisTableData));
                    vm.$emit('on-change', vm.handleBackdata(vm.thisTableData), index);
                }
            }
        }
    }, currentRow.editting ? '保存' : '编辑');
};

const addButton = (vm, h, currentRow, index) => {
    return h('Button', {
        props: {
            type:'success',
            size: 'small'
        },
        style: {
            margin: '0 5px'
        },
        on: {
            'click': () => {
                vm.thisTableData.splice(index+1 , 0,{});
                vm.$emit('input', vm.handleBackdata(vm.thisTableData));
                vm.$emit('on-change', vm.handleBackdata(vm.thisTableData), index);
            }
        }
    }, '新增');
};

const deleteButton = (vm, h, currentRow, index) => {
    return h('Poptip', {
        props: {
            confirm: true,
            title: '您确定要删除这条数据吗?',
            transfer: true
        },
        on: {
            'on-ok': () => {
                vm.thisTableData.splice(index, 1);
                vm.$emit('input', vm.handleBackdata(vm.thisTableData));
                vm.$emit('on-delete', vm.handleBackdata(vm.thisTableData), index);
            }
        }
    }, [
        h('Button', {
            style: {
                margin: '0 5px'
            },
            props: {
                type: 'error',
                placement: 'top',
                size: 'small'
            }
        }, '删除')
    ]);
};

export default {
    name: 'myEditTable',
    props: {
        refs: String,
        columnsList: Array,
        value: Array,
        url: String,
        addBtn: {
            type: Boolean,
            default: true
        }
    },
    data () {
        return {
            columns: [],
            thisTableData: [],
            edittingStore: [],
            dicts:{}
        };
    },
    created () {
        this.init();
    },
    methods: {
        init () {
            let vm = this;

            let editableCell = this.columnsList.filter(item => {
                if (item.editable) {
                    if (item.editable === true) {
                        if(item.select_cfg && !this.dicts[item.select_cfg]){
                            this.dicts[item.select_cfg]=util.showDictList( item.select_cfg);
                        }
                        return item;
                    }
                }
            });

            let cloneData = this.value ? JSON.parse(JSON.stringify(this.value)) : [];

            if(cloneData.length == 0 ){
                cloneData.push({});
            }
            let res = [];
            res = cloneData.map((item, index) => {
                let isEditting = false;
                if (this.thisTableData[index]) {
                    if (this.thisTableData[index].editting) {
                        isEditting = true;
                    } else {
                        for (const cell in this.thisTableData[index].edittingCell) {
                            if (this.thisTableData[index].edittingCell[cell] === true) {
                                isEditting = true;
                            }
                        }
                    }
                }

                if (isEditting) {
                    return this.thisTableData[index];
                } else {
                    this.$set(item, 'editting', false);
                    let edittingCell = {};
                    editableCell.forEach(item => {
                        edittingCell[item.key] = false;
                    });
                    this.$set(item, 'edittingCell', edittingCell);
                    return item;
                }
            });
            this.thisTableData = res;
            this.edittingStore = JSON.parse(JSON.stringify(this.thisTableData));

            this.columnsList.forEach(item => {
                if (item.editable) {
                    item.render = (h, param) => {
                        let currentRow = this.thisTableData[param.index];
                        if (!currentRow.editting) {
                            let _v = currentRow[item.key];
                            let v = item.select_cfg &&_v  ? util.showDictLabel(item.select_cfg,_v) :_v ;
                            return h('span', v );
                        } else {
                            if(item.select_cfg && this.dicts[item.select_cfg] ){
                                return h('Select', {
                                    props: {
                                        value: currentRow[item.key], // 获取选择的下拉框的值
                                        size: 'small'
                                    },
                                    on: {
                                        'on-change': e => {
                                            let key = param.column.key;
                                            vm.edittingStore[param.index][key] = e;
                                        }
                                    }
                                }, this.dicts[item.select_cfg] .map((item) => { // this.productTypeList下拉框里的data
                                    return h('Option', { // 下拉框的值
                                        props: {
                                            value: item.value,
                                            label: item.label
                                        }
                                    })
                                }))
                            }else{
                                return h('Input', {
                                    props: {
                                        type: 'text',
                                        value: currentRow[item.key]
                                    },
                                    on: {
                                        'on-change' (event) {
                                            let key = param.column.key;
                                            vm.edittingStore[param.index][key] = event.target.value;
                                        }
                                    }
                                });
                            }
                        }
                    };
                }
                if (item.handle) {
                    item.render = (h, param) => {
                        let currentRowData = this.thisTableData[param.index];
                        if (item.handle.length === 2) {
                            return h('div', [
                                editButton(this, h, currentRowData, param.index),
                                deleteButton(this, h, currentRowData, param.index),
                                addButton(this, h, currentRowData, param.index)
                            ]);
                        } else if (item.handle.length === 1) {
                            if (item.handle[0] === 'edit') {
                                return h('div', [
                                    editButton(this, h, currentRowData, param.index),
                                    addButton(this, h, currentRowData, param.index)
                                ]);
                            } else {
                                return h('div', [
                                    deleteButton(this, h, currentRowData, param.index),
                                    addButton(this, h, currentRowData, param.index)
                                ]);
                            }
                        }
                    };
                }
            });
        },
        handleBackdata (data) {
            let clonedData = JSON.parse(JSON.stringify(data));
            clonedData.forEach(item => {
                delete item.editting;
                delete item.edittingCell;
                delete item.saving;
            });
            return clonedData;
        }
    },
    watch: {

        value: {
            handler () {
                console.log("data changed");
                this.init();
            },
            deep: true,
            immediate: true,
        },
        columnsList(){
            this.init();
        }
    }
};
</script>
