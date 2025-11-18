<template>
  <div class="p-2">
    <!--查询区域456-->
    <div class="jeecg-basic-table-form-container">
      <a-form ref="formRef" @keyup.enter.native="searchQuery" :model="queryParam" :label-col="labelCol" :wrapper-col="wrapperCol">
        <a-row :gutter="24">
          <a-col :lg="6">
            <a-form-item name="courseId">
              <template #label><span title="课程编码">课程编码</span></template>
              <j-popup
                placeholder="请选择课程编码" 
                v-model:value="queryParam.courseId" 
                code="demo"
                :fieldConfig="[
                  { source: 'id', target: 'courseId' },
                ]"
                :multi="true"
                :setFieldsValue="setFieldsValue" />
            </a-form-item>
          </a-col>
          <a-col :lg="6">
            <a-form-item name="courseName">
              <template #label><span title="课程名称">课程名称</span></template>
              <a-input placeholder="请输入课程名称" v-model:value="queryParam.courseName" allow-clear ></a-input>
            </a-form-item>
          </a-col>
          <template v-if="toggleSearchStatus">
            <a-col :lg="6">
              <a-form-item name="teacherId">
                <template #label><span title="讲师编码">讲师编码</span></template>
                <a-input placeholder="请输入讲师编码" v-model:value="queryParam.teacherId" allow-clear ></a-input>
              </a-form-item>
            </a-col>
            <a-col :lg="6">
              <a-form-item name="teacherName">
                <template #label><span title="讲师">讲师</span></template>
                <a-input placeholder="请输入讲师" v-model:value="queryParam.teacherName" allow-clear ></a-input>
              </a-form-item>
            </a-col>
            <a-col :lg="6">
              <a-form-item name="beginTime">
                <template #label><span title="开始时间">开始时间</span></template>
                <a-date-picker valueFormat="YYYY-MM-DD" placeholder="请选择开始时间"  v-model:value="queryParam.beginTime" allow-clear />
              </a-form-item>
            </a-col>
            <a-col :lg="6">
              <a-form-item name="endTime">
                <template #label><span title="结束时间">结束时间</span></template>
                <a-date-picker valueFormat="YYYY-MM-DD" placeholder="请选择结束时间"  v-model:value="queryParam.endTime" allow-clear />
              </a-form-item>
            </a-col>
            <a-col :lg="6">
              <a-form-item name="courserTag">
                <template #label><span title="课程标签">课程标签</span></template>
                <j-select-multiple placeholder="请选择课程标签" dictCode="course_tag" v-model:value="queryParam.courserTag" allow-clear />
              </a-form-item>
            </a-col>
          </template>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <span style="float: left; overflow: hidden" class="table-page-search-submitButtons">
              <a-col :lg="6">
                <a-button type="primary" preIcon="ant-design:search-outlined" @click="searchQuery">查询</a-button>
                <a-button type="primary" preIcon="ant-design:reload-outlined" @click="searchReset" style="margin-left: 8px">重置</a-button>
                <a @click="toggleSearchStatus = !toggleSearchStatus" style="margin-left: 8px">
                  {{ toggleSearchStatus ? '收起' : '展开' }}
                  <Icon :icon="toggleSearchStatus ? 'ant-design:up-outlined' : 'ant-design:down-outlined'" />
                </a>
              </a-col>
            </span>
          </a-col>
        </a-row>
      </a-form>
    </div>
    <!--引用表格-->
    <BasicTable @register="registerTable" :rowSelection="rowSelection">
      <!--插槽:table标题-->
      <template #tableTitle>
        <a-button type="primary" v-auth="'test:test_course:add'"  @click="handleAdd" preIcon="ant-design:plus-outlined"> 新增</a-button>
        <a-button  type="primary" v-auth="'test:test_course:exportXls'" preIcon="ant-design:export-outlined" @click="onExportXls"> 导出</a-button>
        <j-upload-button  type="primary" v-auth="'test:test_course:importExcel'"  preIcon="ant-design:import-outlined" @click="onImportXls">导入</j-upload-button>
        <a-dropdown v-if="selectedRowKeys.length > 0">
          <template #overlay>
            <a-menu>
              <a-menu-item key="1" @click="batchHandleDelete">
                <Icon icon="ant-design:delete-outlined"></Icon>
                删除
              </a-menu-item>
            </a-menu>
          </template>
          <a-button v-auth="'test:test_course:deleteBatch'">批量操作
            <Icon icon="mdi:chevron-down"></Icon>
          </a-button>
        </a-dropdown>
        <!-- 高级查询 -->
        <super-query :config="superQueryConfig" @search="handleSuperQuery" />
      </template>
      <!--操作栏-->
      <template #action="{ record }">
        <TableAction :actions="getTableAction(record)" :dropDownActions="getDropDownAction(record)"/>
      </template>
      <template v-slot:bodyCell="{ column, record, index, text }">
      </template>
    </BasicTable>
    <!-- 表单区域 -->
    <TestCourseModal ref="registerModal" @success="handleSuccess"></TestCourseModal>
  </div>
</template>

<script lang="ts" name="test-testCourse" setup>
  import { ref, reactive } from 'vue';
  import { BasicTable, useTable, TableAction } from '/@/components/Table';
  import { useListPage } from '/@/hooks/system/useListPage';
  import { columns, superQuerySchema } from './TestCourse.data';
  import { list, deleteOne, batchDelete, getImportUrl, getExportUrl } from './TestCourse.api';
  import { downloadFile } from '/@/utils/common/renderUtils';
  import TestCourseModal from './components/TestCourseModal.vue'
  import { useUserStore } from '/@/store/modules/user';
  import { useMessage } from '/@/hooks/web/useMessage';
   import {useModal} from '/@/components/Modal';
  import JDictSelectTag from '/@/components/Form/src/jeecg/components/JDictSelectTag.vue';
  import JSelectMultiple from '/@/components/Form/src/jeecg/components/JSelectMultiple.vue';
  import JPopup from '/@/components/Form/src/jeecg/components/JPopup.vue';
  import { getDateByPicker } from '/@/utils';

  const fieldPickers = reactive({
  });

  const formRef = ref();
  const queryParam = reactive<any>({});
  const toggleSearchStatus = ref<boolean>(false);
  const registerModal = ref();
  const userStore = useUserStore();
  const { createMessage } = useMessage();
  //注册table数据
  const { prefixCls, tableContext, onExportXls, onImportXls } = useListPage({
    tableProps: {
      title: '测试_课程表',
      api: list,
      columns,
      canResize:true,
      useSearchForm: false,
      actionColumn: {
        width: 120,
        fixed: 'right',
      },
      beforeFetch: async (params) => {
        for (let key in fieldPickers) {
          if (queryParam[key] && fieldPickers[key]) {
            queryParam[key] = getDateByPicker(queryParam[key], fieldPickers[key]);
          }
        }
        return Object.assign(params, queryParam);
      },
    },
    exportConfig: {
      name: "测试_课程表",
      url: getExportUrl,
      params: queryParam,
    },
	  importConfig: {
	    url: getImportUrl,
	    success: handleSuccess
	  },
  });
  const [registerTable, { reload, collapseAll, updateTableDataRecord, findTableDataRecord, getDataSource }, { rowSelection, selectedRowKeys }] = tableContext;
  const labelCol = reactive({
    xs:24,
    sm:4,
    xl:6,
    xxl:4
  });
  const wrapperCol = reactive({
    xs: 24,
    sm: 20,
  });

  // 高级查询配置
  const superQueryConfig = reactive(superQuerySchema);

  /**
   * 高级查询事件
   */
  function handleSuperQuery(params) {
    Object.keys(params).map((k) => {
      queryParam[k] = params[k];
    });
    searchQuery();
  }

  /**
   * 新增事件
   */
  function handleAdd() {
    registerModal.value.disableSubmit = false;
    registerModal.value.add();
  }
  
  /**
   * 编辑事件
   */
  function handleEdit(record: Recordable) {
    registerModal.value.disableSubmit = false;
    registerModal.value.edit(record);
  }
   
  /**
   * 详情
   */
  function handleDetail(record: Recordable) {
    registerModal.value.disableSubmit = true;
    registerModal.value.edit(record);
  }
   
  /**
   * 删除事件
   */
  async function handleDelete(record) {
    await deleteOne({ id: record.id }, handleSuccess);
  }
   
  /**
   * 批量删除事件
   */
  async function batchHandleDelete() {
    await batchDelete({ ids: selectedRowKeys.value }, handleSuccess);
  }
   
  /**
   * 成功回调
   */
  function handleSuccess() {
    (selectedRowKeys.value = []) && reload();
  }
   
  /**
   * 操作栏
   */
  function getTableAction(record) {
    return [
      {
        label: '编辑',
        onClick: handleEdit.bind(null, record),
        auth: 'test:test_course:edit'
      },
    ];
  }
   
  /**
   * 下拉操作栏
   */
  function getDropDownAction(record) {
    return [
      {
        label: '详情',
        onClick: handleDetail.bind(null, record),
      }, {
        label: '删除',
        popConfirm: {
          title: '是否确认删除',
          confirm: handleDelete.bind(null, record),
          placement: 'topLeft',
        },
        auth: 'test:test_course:delete'
      }
    ]
  }

  /**
   * 查询
   */
  function searchQuery() {
    reload();
  }
  
  /**
   * 重置
   */
  function searchReset() {
    formRef.value.resetFields();
    selectedRowKeys.value = [];
    //刷新数据
    reload();
  }
  
  /**
   *  popup组件值改变事件
   */
  function setFieldsValue(map) {
    Object.keys(map).map((key) => {
      queryParam[key] = map[key];
    });
  }





</script>

<style lang="less" scoped>
  .jeecg-basic-table-form-container {
    padding: 0;
    .table-page-search-submitButtons {
      display: block;
      margin-bottom: 24px;
      white-space: nowrap;
    }
    .query-group-cust{
      min-width: 100px !important;
    }
    .query-group-split-cust{
      width: 30px;
      display: inline-block;
      text-align: center
    }
    .ant-form-item:not(.ant-form-item-with-help){
      margin-bottom: 16px;
      height: 32px;
    }
    :deep(.ant-picker),:deep(.ant-input-number){
      width: 100%;
    }
    // 水平多选框解决方案
  .ant-select-multiple {

    :deep(.ant-select-selector) {
      cursor: default;
    }

    :deep(.ant-select-selection-search-input) {
      // 使输入框无法接收焦点
      caret-color: transparent;
    }

    // 核心：使用弹性布局实现水平排列
    :deep(.ant-select-selection-overflow) {
      display: flex;
      flex-wrap: nowrap; // 禁止换行
      overflow-x: hidden;  // 水平滚动
      overflow-y: hidden; // 禁用垂直滚动
      max-height: 32px;  // 保持原有高度
      
      // 美化滚动条
      scrollbar-width: none;
      
      &::-webkit-scrollbar {
        display: none;
      }
      
      &:hover,
      &:focus-within {
        overflow-x: auto; // 内容溢出时显示滚动条
        scrollbar-width: thin; /* 兼容 Firefox */

        &::-webkit-scrollbar {
          display: block; // 在 Webkit 浏览器中显示滚动条
          height: 4px; // 设置水平滚动条高度
        }
        &::-webkit-scrollbar-thumb {
          background-color: #d9d9d9; // 滑块颜色
          border-radius: 2px;
        }
        &::-webkit-scrollbar-thumb:hover {
          background-color: #bfbfbf;
        }
      }
    }
    
    // 选项项样式调整
      :deep(.ant-select-selection-overflow-item) {
        flex-shrink: 0; // 防止选项被压缩
        margin-bottom: 0; // 移除底部边距
        
        // 选项标签样式
        .ant-select-selection-item {
          max-width: 120px; // 限制单个选项最大宽度
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }
      }
      
      // 搜索输入框样式
      :deep(.ant-select-selection-search) {
        margin-left: 4px;
      }
    }
  }
</style>
