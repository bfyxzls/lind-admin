package com.lind.lindadmin.service.impl;

import com.lind.lindadmin.common.BusinessException;
import com.lind.lindadmin.common.PageResult;
import com.lind.lindadmin.entity.DictData;
import com.lind.lindadmin.entity.DictType;
import com.lind.lindadmin.repository.DictDataRepository;
import com.lind.lindadmin.repository.DictTypeRepository;
import com.lind.lindadmin.service.DictService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 数据字典服务实现类
 */
@Service
@RequiredArgsConstructor
public class DictServiceImpl implements DictService {

    private final DictTypeRepository dictTypeRepository;
    private final DictDataRepository dictDataRepository;

    // ==================== 字典类型 ====================

    @Override
    public DictType findTypeById(Long id) {
        return dictTypeRepository.findById(id)
                .filter(d -> d.getDeleted() == 0)
                .orElseThrow(() -> new BusinessException("字典类型不存在"));
    }

    @Override
    public DictType findTypeByCode(String dictType) {
        return dictTypeRepository.findByDictTypeAndDeleted(dictType, 0).orElse(null);
    }

    @Override
    public PageResult<DictType> findTypePage(String dictName, String dictType, Integer status, Integer pageNum, Integer pageSize) {
        Pageable pageable = PageRequest.of(pageNum - 1, pageSize);
        Page<DictType> page = dictTypeRepository.findByConditions(
                dictName != null && !dictName.isEmpty() ? dictName : null,
                dictType != null && !dictType.isEmpty() ? dictType : null,
                status,
                pageable
        );
        return PageResult.of(page);
    }

    @Override
    public List<DictType> findAllTypes() {
        return dictTypeRepository.findByDeletedOrderByIdAsc(0);
    }

    @Override
    @Transactional
    public DictType saveType(DictType dictType) {
        // 检查字典类型是否存在
        if (dictTypeRepository.existsByDictTypeAndDeleted(dictType.getDictType(), 0)) {
            throw new BusinessException("字典类型已存在");
        }
        dictType.setDeleted(0);
        return dictTypeRepository.save(dictType);
    }

    @Override
    @Transactional
    public DictType updateType(DictType dictType) {
        DictType existingDictType = findTypeById(dictType.getId());
        
        existingDictType.setDictName(dictType.getDictName());
        existingDictType.setStatus(dictType.getStatus());
        existingDictType.setRemark(dictType.getRemark());
        
        return dictTypeRepository.save(existingDictType);
    }

    @Override
    @Transactional
    public void deleteType(Long id) {
        DictType dictType = findTypeById(id);
        dictType.setDeleted(1);
        dictTypeRepository.save(dictType);
    }

    // ==================== 字典数据 ====================

    @Override
    public DictData findDataById(Long id) {
        return dictDataRepository.findById(id)
                .filter(d -> d.getDeleted() == 0)
                .orElseThrow(() -> new BusinessException("字典数据不存在"));
    }

    @Override
    public List<DictData> findDataByType(String dictType) {
        return dictDataRepository.findByDictTypeAndDeletedOrderBySortOrderAsc(dictType, 0);
    }

    @Override
    public PageResult<DictData> findDataPage(String dictType, String dictLabel, Integer status, Integer pageNum, Integer pageSize) {
        Pageable pageable = PageRequest.of(pageNum - 1, pageSize);
        Page<DictData> page = dictDataRepository.findByConditions(
                dictType != null && !dictType.isEmpty() ? dictType : null,
                dictLabel != null && !dictLabel.isEmpty() ? dictLabel : null,
                status,
                pageable
        );
        return PageResult.of(page);
    }

    @Override
    @Transactional
    public DictData saveData(DictData dictData) {
        dictData.setDeleted(0);
        return dictDataRepository.save(dictData);
    }

    @Override
    @Transactional
    public DictData updateData(DictData dictData) {
        DictData existingDictData = findDataById(dictData.getId());
        
        existingDictData.setDictLabel(dictData.getDictLabel());
        existingDictData.setDictValue(dictData.getDictValue());
        existingDictData.setCssClass(dictData.getCssClass());
        existingDictData.setListClass(dictData.getListClass());
        existingDictData.setSortOrder(dictData.getSortOrder());
        existingDictData.setStatus(dictData.getStatus());
        existingDictData.setIsDefault(dictData.getIsDefault());
        existingDictData.setRemark(dictData.getRemark());
        
        return dictDataRepository.save(existingDictData);
    }

    @Override
    @Transactional
    public void deleteData(Long id) {
        DictData dictData = findDataById(id);
        dictData.setDeleted(1);
        dictDataRepository.save(dictData);
    }

    @Override
    @Transactional
    public void deleteDataBatch(List<Long> ids) {
        ids.forEach(this::deleteData);
    }
}

