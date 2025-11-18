-- 修改商品
update fts_product set product_name_cn = concat('艾宾 ',SUBSTR(product_name_cn,locate(' ',product_name_cn),LENGTH(product_name_cn)))
	,product_name_en = concat('abeam ',SUBSTR(product_name_en,locate(' ',product_name_en),LENGTH(product_name_en)))
	,brand_name = concat('ABeam ',left(brand_name,2))



update fts_product set product_name_cn = concat(SUBSTRING(product_name_cn, 1, CHAR_LENGTH(product_name_cn) - 3),REPEAT('*', 3))
	,product_name_en = concat(SUBSTRING(product_name_en, 1, CHAR_LENGTH(product_name_en) - 6),REPEAT('*', 6))
	
update fts_product set product_name_cn = concat('艾宾',right(brand_name,2),product_name_cn)
where product_name_cn = '***'

update fts_product_merge A
inner join fts_product B on A.product_oracle_code = B.product_oracle_code
set A.product_name = B.product_name_cn

-- 修改订单
update fts_customer_order_v2 A
inner join fts_customer B on A.customer_id = B.customer_code
and B.customer_type = 'ORGANIZATION'
set A.billing_client = B.customer_name,A.customer_shipping_address = B.address_line1

update fts_customer_order_detail_v2 A
inner join vw_fts_product_all B on A.product_code = B.product_code
set A.product_name = B.product_name,A.product_name_en = B.product_name_en,A.brand_name = B.brand_name

update fts_customer_order_detail_v2 A
inner join vw_fts_product_all B on A.product_oracle_code = B.product_oracle_code
set A.product_name = B.product_name,A.product_name_en = B.product_name_en,A.brand_name = B.brand_name


-- 销售计划代理商
update fts_demension_item set demension_item_name = concat(left(demension_item_name,2),'**',SUBSTR(demension_item_name from 5 for LENGTH(demension_item_name)))
where demension_code in  ('CI_import_001_2','CI_import_002_2','CI_year_009_1','CI_year_008_1','CI_month_001_1','CI_month_002_1')
and demension_item_name not like '%合计%'

update fts_demension_item set 
demension_item_name = case when demension_item_name = '华东大润发（上海路捷）' then '华东大润发（上海**）'
		when demension_item_name = '东北大润发（大连康乐美）' then '东北大润发（大连***）'
		when demension_item_name = '华南大润发（BIC广州）' then '华南大润发（***广州）'
		when demension_item_name = '华北大润发（青岛德汇通）' then '华北大润发（青岛**）'
		else 1
	end
where demension_code in  ('CI_import_002_3','CI_year_010_1','CI_month_003_1')
and demension_item_name in ('华东大润发（上海路捷）','东北大润发（大连康乐美）','华南大润发（BIC广州）','华北大润发（青岛德汇通）')

update fts_mapping_customer set customer_upper_name = concat(left(customer_upper_name,2),'**',SUBSTR(customer_upper_name from 5 for LENGTH(customer_upper_name)))

-- 销售计划品牌
update fts_mapping_brand set plan_brand_name = concat('ABeam ',left(plan_brand_name,2)),actual_brand_name = concat('ABeam ',left(actual_brand_name,2))

update fts_demension_item set demension_item_name = 'ABeam Ku' where demension_item_name = 'Kuyura';
update fts_demension_item set demension_item_name = 'ABeam HA' where demension_item_name = 'HADASUI';
update fts_demension_item set demension_item_name = 'ABeam MA' where demension_item_name = 'MA CHERIE';
update fts_demension_item set demension_item_name = 'ABeam RI' where demension_item_name = 'RICLIN';
update fts_demension_item set demension_item_name = 'ABeam UN' where demension_item_name = 'UNO';
update fts_demension_item set demension_item_name = 'ABeam SE' where demension_item_name = 'SENKA';
update fts_demension_item set demension_item_name = 'ABeam TS' where demension_item_name = 'TSUBAKI';
update fts_demension_item set demension_item_name = 'ABeam AQ' where demension_item_name = 'AQUAIR';
update fts_demension_item set demension_item_name = 'ABeam Fi' where demension_item_name = 'Fino';
update fts_demension_item set demension_item_name = 'ABeam SU' where demension_item_name = 'SUPER MILD';


update fts_demension_item set demension_item_name = 'ABeam AG' where demension_item_name = 'AG';
update fts_demension_item set demension_item_name = 'ABeam SN' where demension_item_name = 'SNK-AP';
update fts_demension_item set demension_item_name = 'ABeam MR' where demension_item_name = 'MR';
update fts_demension_item set demension_item_name = 'ABeam +t' where demension_item_name = '+tmr';
update fts_demension_item set demension_item_name = 'ABeam UN' where demension_item_name = 'UNO';
update fts_demension_item set demension_item_name = 'ABeam SE' where demension_item_name = 'SENKA';
update fts_demension_item set demension_item_name = 'ABeam TS' where demension_item_name = 'TSUBAKI';
update fts_demension_item set demension_item_name = 'ABeam 尿素' where demension_item_name = '尿素';
update fts_demension_item set demension_item_name = 'ABeam Fi' where demension_item_name = 'Fino';
update fts_demension_item set demension_item_name = 'ABeam Se' where demension_item_name = 'Sea Breeze';

update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'FINO','FI**')
where demension_item_name like '%FINO%' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'FINO','Fine*****')
where demension_item_name like '%Finetoday%' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'润合美','润**')
where demension_item_name like '%润合美%' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'优趣汇','优*汇')
where demension_item_name like '%优趣汇%' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';

update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'游仁','游*')
where demension_item_name like '%游仁%' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'武汉瑞仕昌达','武汉****')
where demension_item_name like '%武汉瑞仕昌达%' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'重庆铃宇','重庆**')
where demension_item_name like '%重庆铃宇%' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'上海鲲驰','上海鲲*')
where demension_item_name like '%上海鲲驰%' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'苏州弘笑','苏州弘*')
where demension_item_name like '%苏州弘笑%' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';

update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'UNO','UN*')
where demension_item_name like '%UNO%' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'优尊','优*')
where demension_item_name = '优尊' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'山西商事','山西商**')
where demension_item_name = '山西商事' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'优尊','优*')
where demension_item_name = '优尊' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'鲲驰','鲲*')
where demension_item_name = '鲲驰' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'东和','东*')
where demension_item_name = '东和' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'塞夫','塞*')
where demension_item_name = '塞夫' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';

update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'优尊','优*')
where left(demension_item_name,1) = '2' and demension_item_name like '%优尊%' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'山西商事','山西商**')
where left(demension_item_name,1) = '2' and demension_item_name like '%山西商事%' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'优尊','优*')
where left(demension_item_name,1) = '2' and demension_item_name like '%优尊%' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'鲲驰','鲲*')
where left(demension_item_name,1) = '2' and demension_item_name like '%鲲驰%' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'东和','东*')
where left(demension_item_name,1) = '2' and demension_item_name like '%东和%' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'塞夫','塞*')
where left(demension_item_name,1) = '2' and demension_item_name like '%塞夫%' and demension_item_name not like '%*%' and demension_item_name not like '%ABeam%';


update fts_demension set demension_name = case when demension_name like '%象屿%' then REPLACE(demension_name,'象屿','象*')
		when demension_name like '%山西%' then REPLACE(demension_name,'山西','山西*')
		when demension_name like '%远泰%' then REPLACE(demension_name,'远泰','远*')
		when demension_name like '%优尊%' then REPLACE(demension_name,'优尊','优*')
		when demension_name like '%鲲驰%' then REPLACE(demension_name,'鲲驰','鲲*')
		when demension_name like '%东和%' then REPLACE(demension_name,'东和','东*')
		when demension_name like '%塞夫%' then REPLACE(demension_name,'塞夫','塞*')
		when demension_name like '%FINO%' then REPLACE(demension_name,'FINO','FI**')
		when demension_name like '%UNO%' then REPLACE(demension_name,'UNO','UN*')
		when demension_name like '%SENKA%' then REPLACE(demension_name,'SENKA','SE***')
		when demension_name like '%TSUBAKI%' then REPLACE(demension_name,'TSUBAKI','TS****')
		else demension_name
	end
	,demension_title = case when demension_title like '%象屿%' then REPLACE(demension_title,'象屿','象*')
		when demension_title like '%山西%' then REPLACE(demension_title,'山西','山西*')
		when demension_title like '%远泰%' then REPLACE(demension_title,'远泰','远*')
		when demension_title like '%优尊%' then REPLACE(demension_title,'优尊','优*')
		when demension_title like '%鲲驰%' then REPLACE(demension_title,'鲲驰','鲲*')
		when demension_title like '%东和%' then REPLACE(demension_title,'东和','东*')
		when demension_title like '%塞夫%' then REPLACE(demension_title,'塞夫','塞*')
		when demension_title like '%FINO%' then REPLACE(demension_title,'FINO','FI**')
		when demension_title like '%UNO%' then REPLACE(demension_title,'UNO','UN*')
		when demension_title like '%SENKA%' then REPLACE(demension_title,'SENKA','SE***')
		when demension_title like '%TSUBAKI%' then REPLACE(demension_title,'TSUBAKI','TS****')
		else demension_title
	end
	
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'鲲驰','鲲*');
update fts_demension_item set demension_item_name = REPLACE(demension_item_name,'路捷','路*');

update fts_actual_export A
inner join fts_mapping_customer B on A.demension_item_code = B.demension_item_code
and B.demension_code = 'CI_import_002_2' and A.data_type = 'ST'
set A.customer_name = B.customer_upper_name
update fts_actual_export set brand = concat('ABeam ',left(brand,2))

update fts_plan_actual set demension_item = concat('ABeam ',left(demension_item,2)) where demension_type = 'brand';

update fts_actual set brand = concat('ABeam ',left(brand,2))
where brand not like '%brand%' and brand not like '%qd%' and brand not like '%GMV%'

update fts_mapping_actual set brand = concat('ABeam ',left(brand,2))
where brand is not null and brand <> 'xxx' and brand not like '%brand%' and brand not like '%qd%' and brand not like '%GMV%'


-- 库存数据
update fts_inventory_oracle A
inner join vw_fts_product_all B on A.product_oracle_code = B.product_oracle_code
set A.product_name = B.product_name

update fts_inventory_wms A
inner join vw_fts_product_all B on A.product_code = B.product_oracle_code
set A.product_name = B.product_name
update fts_inventory_wms_history A
inner join vw_fts_product_all B on A.product_code = B.product_oracle_code
set A.product_name = B.product_name


-- 需求预测
update fts_product_virtual set product_name_cn = concat('艾宾 ',SUBSTR(product_name_cn,locate(' ',product_name_cn),LENGTH(product_name_cn)))
	,brand_name = concat('ABeam ',left(brand_name,2))

update fts_product_virtual set product_name_cn = concat(SUBSTRING(product_name_cn, 1, CHAR_LENGTH(product_name_cn) - 3),REPEAT('*', 3))
	,product_name_en = concat(SUBSTRING(product_name_en, 1, CHAR_LENGTH(product_name_en) - 6),REPEAT('*', 6))
	
update fts_product_virtual set product_name_cn = concat('艾宾',right(brand_name,2),product_name_cn)
where product_name_cn = '***'

update fts_md set desc_cn = concat('艾宾 ',SUBSTR(desc_cn,locate(' ',desc_cn),LENGTH(desc_cn)))
	,brand = concat('ABeam ',left(brand,2))

update fts_md set desc_cn = concat(SUBSTRING(desc_cn, 1, CHAR_LENGTH(desc_cn) - 3),REPEAT('*', 3))
	
update fts_md set desc_cn = concat('艾宾',right(brand,2),desc_cn)
where desc_cn = '***'

-- 店出表
update fts_agent_delivery A
inner join fts_customer B on A.customer_code = B.customer_code and B.customer_type = 'ORGANIZATION'
set A.customer_name_new = B.customer_name,A.customer_name = B.customer_name

-- 系统用户
UPDATE sys_user 
SET username = REPLACE(username, 'fts', 'ab')
WHERE username LIKE 'fts%';

UPDATE sys_user 
SET realname = '夏兴'
WHERE realname LIKE '夏%';

UPDATE sys_user 
SET phone = CONCAT(
    LEFT(phone, 3), 
    '****', 
    RIGHT(phone, 4)
)
WHERE LENGTH(phone) = 11;

UPDATE sys_user 
SET work_no = username 
WHERE username LIKE 'ab%' AND work_no LIKE 'fts%';

-- 选取营业窗口出现频率前三位作为“张三”“李四”“王五”
WITH ranked_sales AS (
  SELECT 
    sales_charge,
    COUNT(*) as frequency,
    ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC, sales_charge) as rank_num
  FROM fts_sales_organization
  WHERE sales_charge IS NOT NULL AND sales_charge != ''
  GROUP BY sales_charge
)
UPDATE sys_user u
JOIN ranked_sales r ON u.username = r.sales_charge
SET u.realname = 
  CASE r.rank_num
    WHEN 1 THEN '张三'
    WHEN 2 THEN '李四' 
    WHEN 3 THEN '王五'
  END
WHERE r.rank_num <= 3;

-- 选取营业总监出现频率前三位作为“赵六”“陈七”“周八”
WITH ranked_sales AS (
  SELECT 
    sales_director,
    COUNT(*) as frequency,
    ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC, sales_director) as rank_num
  FROM fts_sales_organization
  WHERE sales_director IS NOT NULL AND sales_director != ''
  GROUP BY sales_director
)
UPDATE sys_user u
JOIN ranked_sales r ON u.username = r.sales_director
SET u.realname = 
  CASE r.rank_num
    WHEN 1 THEN '赵六'
    WHEN 2 THEN '陈七'
    WHEN 3 THEN '周八' 
    ELSE realname
  END
WHERE r.rank_num <= 3;

-- 营业vp的所有人为姓+总
UPDATE sys_user
SET realname = CONCAT(LEFT(realname,1), '总')
WHERE username IN (
	SELECT DISTINCT vp
	FROM fts_sales_organization
        );


-- 选取订单审核频率最高的人作为'吴九'
UPDATE sys_user
SET realname = '吴九'
WHERE username = (
	SELECT order_audit FROM (
		SELECT order_audit, COUNT(*) as count
		FROM fts_sales_organization
		GROUP BY order_audit
		ORDER BY count DESC
		LIMIT 1
		) a );

-- 销售大区
UPDATE fts_sales_organization so
INNER JOIN fts_customer fc ON so.customer_code = fc.customer_code
SET so.customer_name = fc.customer_name
WHERE fc.customer_name IS NOT NULL;

UPDATE fts_sales_organization 
SET 
    sales_director = REPLACE(sales_director, 'fts', 'ab'),
    sales_charge = REPLACE(sales_charge, 'fts', 'ab'), 
    vp = REPLACE(vp, 'fts', 'ab'),
    order_audit = REPLACE(order_audit, 'fts', 'ab')
WHERE sales_director LIKE 'fts%' 
   OR sales_charge LIKE 'fts%' 
   OR vp LIKE 'fts%' 
   OR order_audit LIKE 'fts%';

-- 系统菜单
UPDATE sys_permission
SET name = REPLACE(name, 'FTS', 'ABeam')
WHERE name LIKE 'FTS%';

-- 商品折扣一览
DROP PROCEDURE IF EXISTS batch_update_discount;

-- 创建存储过程
DELIMITER $$
CREATE PROCEDURE batch_update_discount()
BEGIN
    DECLARE v_total_records INT DEFAULT 0;
    DECLARE v_batch_size INT DEFAULT 10000;
    DECLARE v_offset INT DEFAULT 0;
    
    -- 1. 创建临时表存储映射关系
    DROP TEMPORARY TABLE IF EXISTS temp_product_mapping;
    CREATE TEMPORARY TABLE temp_product_mapping AS
    SELECT d.id as discount_id, p.product_name_cn
    FROM fts_discount d
    INNER JOIN fts_product p ON d.product_code = p.product_number
    WHERE p.product_name_cn IS NOT NULL;
    
    -- 2. 为临时表创建索引
    CREATE INDEX idx_temp_product ON temp_product_mapping(discount_id);
    
    -- 3. 获取总记录数
    SELECT COUNT(*) INTO v_total_records FROM temp_product_mapping;
    
    -- 4. 分批更新产品名称
    SET v_offset = 0;
    WHILE v_offset < v_total_records DO
        UPDATE fts_discount d
        INNER JOIN (
            SELECT discount_id, product_name_cn 
            FROM temp_product_mapping 
            ORDER BY discount_id 
            LIMIT v_offset, v_batch_size
        ) tmp ON d.id = tmp.discount_id
        SET d.product_name = tmp.product_name_cn;
        
        SET v_offset = v_offset + v_batch_size;
        
        -- 每批提交一次
        COMMIT;
        
        -- 可选：添加延迟
        DO SLEEP(0.1);
    END WHILE;
    
    -- 5. 清理临时表
    DROP TEMPORARY TABLE IF EXISTS temp_product_mapping;
    
END $$
DELIMITER ;

-- 执行存储过程
CALL batch_update_discount();

-- 完成后删除存储过程
DROP PROCEDURE batch_update_discount;

DROP PROCEDURE IF EXISTS batch_update_customer_name;

-- 创建存储过程
DELIMITER $$
CREATE PROCEDURE batch_update_customer_name()
BEGIN
    DECLARE v_total_records INT DEFAULT 0;
    DECLARE v_batch_size INT DEFAULT 10000;
    DECLARE v_offset INT DEFAULT 0;
    
    -- 1. 创建临时表存储客户映射关系
    DROP TEMPORARY TABLE IF EXISTS temp_customer_mapping;
    CREATE TEMPORARY TABLE temp_customer_mapping AS  
    SELECT d.id as discount_id, c.customer_name
    FROM fts_discount d
    INNER JOIN fts_customer c ON d.customer_code = c.customer_code
    WHERE c.customer_name IS NOT NULL;
    
    -- 2. 为临时表创建索引
    CREATE INDEX idx_temp_customer ON temp_customer_mapping(discount_id);
    
    -- 3. 获取总记录数
    SELECT COUNT(*) INTO v_total_records FROM temp_customer_mapping;
    
    -- 4. 分批更新代理商名称
    SET v_offset = 0;
    WHILE v_offset < v_total_records DO
        UPDATE fts_discount d
        INNER JOIN (
            SELECT discount_id, customer_name 
            FROM temp_customer_mapping 
            ORDER BY discount_id 
            LIMIT v_offset, v_batch_size
        ) tmp ON d.id = tmp.discount_id
        SET d.customer_name = tmp.customer_name;
        
        SET v_offset = v_offset + v_batch_size;
        
        -- 每批提交一次
        COMMIT;
        
        -- 可选：添加延迟
        DO SLEEP(0.1);
    END WHILE;
    
    -- 5. 清理临时表
    DROP TEMPORARY TABLE IF EXISTS temp_customer_mapping;
    
END $$
DELIMITER ;

-- 执行存储过程
CALL batch_update_customer_name();

-- 完成后删除存储过程
DROP PROCEDURE batch_update_customer_name;

-- 配额借调
UPDATE fts_allocation_loan loan
INNER JOIN fts_customer fc ON loan.borrower_agent = fc.customer_code
SET loan.borrower_agent_name = fc.customer_name
WHERE fc.customer_name IS NOT NULL;

UPDATE fts_allocation_loan loan
INNER JOIN fts_customer fc ON loan.lender_agent= fc.customer_code
SET loan.lender_agent_name = fc.customer_name
WHERE fc.customer_name IS NOT NULL;

update fts_allocation_loan_detail 
set product_name = CASE WHEN locate(' ',product_name)>2 AND locate(' ',product_name)<5
THEN concat('艾宾 ',repeat('*',2),SUBSTR(product_name,locate(' ',product_name)+1,3),repeat('*',3))
ELSE concat('艾宾',repeat('*',2),substr(product_name,locate('（', product_name)+1,3),repeat('*',3))
END;
