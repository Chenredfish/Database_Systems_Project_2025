# 遊戲傷害計算方式說明

## 🔥 基本概念

### 1. **基本傷害公式**：
```
實際傷害 = ((攻擊力 × 招式倍率 × 屬性加成) × (1 - 物傷減免))
```

---

## 🧮 詳細步驟

### 一、取得攻擊力來源
- 若為物理招式 → 使用「角色物理攻擊」。
- 若為魔法招式 → 使用「角色魔法攻擊」。

並考慮角色狀態加成：
```
攻擊力 = 基礎攻擊力 × (1 + 狀態攻擊加成百分比)
```

---

### 二、屬性倍率加成

你有設計屬性克制與優勢，我們可以設計如下的 **屬性關係表**：

| 屬性 | 克制 | 被克制 |
|------|------|--------|
| 火   | 草   | 水     |
| 水   | 火   | 草     |
| 草   | 水   | 火     |
| 光   | 暗   | 暗     |
| 暗   | 光   | 光     |

倍率設計如下：
- 克制：`x1.5`
- 被克制：`x0.5`
- 無關係：`x1.0`

---

### 三、防禦計算

使用角色裝備防禦數值，也要考慮狀態：
```
物傷減免 = (物防 / (100 + 物防))
```

選擇哪種防禦取決於攻擊類型（物理 or 魔法）。

---

### 四、計算傷害最終公式

```
實際傷害 = ((攻擊力 × 招式倍率 × 屬性加成) × (1 - 物傷減免))
```

#### 最低傷害保底（選擇性）：
避免完全無傷，可以設計一個「最低傷害值」例如 1 或 5% 原始攻擊。

---

## 🧙‍♂️ 角色與招式資訊表

| 項目       | 攻擊者                   | 防禦者                   |
|------------|--------------------------|--------------------------|
| 角色名稱   | 火之劍士                 | 草之守衛                 |
| 屬性       | 火                        | 草                        |
| 攻擊類型   | 物理攻擊                 | —                        |
| 攻擊力     | 100                      | —                        |
| 攻擊狀態   | +20%（攻擊增益）         | -10%（防禦減益）         |
| 有效攻擊力 | 100 × 1.2 = **120**      | —                        |
| 裝備物防   | —                        | 30                       |
| 角色物防   | —                        | 50                       |
| 總物防     | —                        | (50 + 30) × 0.9 = **72** |

---

## 🧨 招式資訊表

| 項目           | 數值        |
|----------------|-------------|
| 招式名稱       | 火焰斬擊    |
| 招式屬性       | 火          |
| 招式倍率       | 1.2         |
| 屬性加成       | 火克草 → **1.5 倍** |

---

## ⚔️ 傷害計算步驟

| 步驟                | 計算式                                   | 結果     |
|---------------------|------------------------------------------|----------|
| 有效攻擊力          | 100 × (1 + 20%)                          | 120      |
| 招式初始傷害        | 120 × 1.2                                | 144      |
| 屬性加成後傷害      | 144 × 1.5                                | 216      |
| 物傷減免          | ((50 + 30) / (100 + 50 + 30)) × (1 - 10%) | 0.4       |
| 最終傷害            | 216 × (1 - 0.4)                          | **129.6**  |

---

✅ **最終結果：這次攻擊造成 130 點傷害(四捨五入)。**

角色 (玩家選擇) Actor:
- **角色代號 (主鍵)** `actor.id`
  1. INTEGER
  2. PRIMARY KEY = true
  3. AUTOINCREMENT = true
  4. NOT NULL = true
  - *Actor ID (Primary Key)*

- **角色名稱 (顯示給玩家)** `actor.name`
  1. TEXT
  2. NOT NULL = true
  - *Actor Name (Displayed to Player)*

- **角色屬性 (火/水/草/雷) (外鍵)** `actor.element`
  1. TEXT
  2. NOT NULL = true
  3. REFERENCES element(name)
  - *Actor Attribute (火系/Water/Grass/Thunder) (Foreign Key)*

- **角色血量** `actor.health`
  1. INTEGER
  2. NOT NULL = true
  3. DEFAULT = 100
  - *Actor Health*

- **角色物理攻擊** `actor.attack_point`
  1. INTEGER
  2. NOT NULL = true
  3. DEFAULT = 10
  - *Actor Physical Attack*

- **角色魔法攻擊** `actor.magic_point`
  1. INTEGER
  2. NOT NULL = true
  3. DEFAULT = 10
  - *Actor Magical Attack*

- **角色物理防禦** `actor.attack_defence`
  1. INTEGER
  2. NOT NULL = true
  3. DEFAULT = 5
  - *Actor Physical Defense*

- **角色魔法防禦** `actor.magic_defence`
  1. INTEGER
  2. NOT NULL = true
  3. DEFAULT = 5
  - *Actor Magical Defense*	

- **角色等級** `actor.level`
  1. INTEGER
  2. NOT NULL = true
  3. DEFAULT = 1
  - *Actor Level*

招式 (玩家選擇) Skill:
- **招式代號 (主鍵)** `skill.id`
  1. INTEGER
  2. PRIMARY KEY = true
  3. AUTOINCREMENT = true
  4. NOT NULL = true
  - *Skill ID (Primary Key)*

- **招式名稱** `skill.name`
  1. TEXT
  2. NOT NULL = true
  - *Skill Name*

- **招式屬性 (火/水/草/雷)** `skill.element`
  1. TEXT
  2. NOT NULL = true
  3. REFERENCES element(name)
  - *Skill Attribute (火系/Water/Grass/Thunder)*

- **招式倍率** `skill.power`
  1. REAL
  2. NOT NULL = true
  3. DEFAULT = 1.0
  - *Skill Power Multiplier*

- **招式冷卻時間** `skill.cooldown`
  1. INTEGER
  2. NOT NULL = true
  3. DEFAULT = 0
  - *Skill Cooldown (Default: 0)*

- **招式等級** `skill.level`
  1. INTEGER
  2. NOT NULL = true
  3. DEFAULT = 1
  - *Skill Level*

- **攻擊類型** `skill.is_magic`
  1. BOOLEAN
  2. NOT NULL = true
  3. DEFAULT = 0
  - *Is Magic Attack (0: Physical, 1: Magic)*

屬性 element:
- **屬性名稱 (主鍵)** `element.name`
  1. TEXT
  2. PRIMARY KEY = true
  3. NOT NULL = true
  - *element Name (Primary Key)*

- **克制屬性** `element.advantage`
  1. TEXT
  2. REFERENCES element(name)
  - *Advantage Attribute (Default: NULL)*

- **被克制屬性** `element.disadvantage`
  1. TEXT
  2. REFERENCES element(name)
  - *Disadvantage Attribute (Default: NULL)*

裝備 (玩家選擇) Equipment:
- **裝備代號 (主鍵)** `equipment.id`
  1. INTEGER
  2. PRIMARY KEY = true
  3. AUTOINCREMENT = true
  4. NOT NULL = true
  - *Equipment ID (Primary Key)*

- **裝備名稱** `equipment.name`
  1. TEXT
  2. NOT NULL = true
  - *Equipment Name*

- **物理防禦** `equipment.attack_defence`
  1. INTEGER
  2. NOT NULL = true
  3. DEFAULT = 0
  - *Equipment Physical Defense (Default: 0)*

- **魔法防禦** `equipment.magic_defence`
  1. INTEGER
  2. NOT NULL = true
  3. DEFAULT = 0
  - *Equipment Magical Defense (Default: 0)*

- **裝備等級** `equipment.level`
  1. INTEGER
  2. NOT NULL = true
  3. DEFAULT = 1
  - *Equipment Level*

狀態 (玩家選擇) Ring:
- **狀態代號** `ring.id`
  1. INTEGER
  2. PRIMARY KEY = true
  3. AUTOINCREMENT = true
  4. NOT NULL = true
  - *Ring ID (Primary Key)*

- **狀態名稱** `ring.name`
  1. TEXT
  2. NOT NULL = true
  - *Ring Name*

- **物理攻擊加成** `ring.attack_power`
  1. INTEGER
  2. NOT NULL = true
  3. DEFAULT = 0
  - *Physical Attack Bonus (Default: 0)*

- **魔法攻擊加成** `ring.magic_power`
  1. INTEGER
  2. NOT NULL = true
  3. DEFAULT = 0
  - *Magical Attack Bonus (Default: 0)*

- **物理防禦加成** `ring.attack_defence`
  1. INTEGER
  2. NOT NULL = true
  3. DEFAULT = 0
  - *Physical Defense Bonus (Default: 0)*

- **魔法防禦加成** `ring.magic_defence`
  1. INTEGER
  2. NOT NULL = true
  3. DEFAULT = 0
  - *Magical Defense Bonus (Default: 0)*

- **血量加成** `ring.health`
  1. INTEGER
  2. NOT NULL = true
  3. DEFAULT = 0
  - *Health Bonus (Default: 0)*

**等級** `ring.level`
1. 同上level


紀錄 (自動新增，無法編輯) Record:
- **遊戲編號** `record.game_id`
  1. INTEGER
  2. NOT NULL = true
  3. 主鍵組合之一

- **戰鬥編號** `record.battle_id`
  1. INTEGER
  2. NOT NULL = true
  3. 主鍵組合之一

- **玩家等級** `record.player_level`
  1. INTEGER
  2. NOT NULL = true

- **掉落裝備** `record.player_equipment_id`
  1. INTEGER
  2. NOT NULL = true
  3. REFERENCES equipment(id)

- **使用技能** `record.player_skill_id`
  1. INTEGER
  2. NOT NULL = true
  3. REFERENCES skill(id)

- **技能選項1** `record.skill_choice_id_1`
  1. INTEGER
  2. NOT NULL = true
  3. REFERENCES skill(id)

- **技能選項2** `record.skill_choice_id_2`
  1. INTEGER
  2. NOT NULL = true
  3. REFERENCES skill(id)

- **技能選項3** `record.skill_choice_id_3`
  1. INTEGER
  2. NOT NULL = true
  3. REFERENCES skill(id)

- **戰前新增狀態** `record.player_ring_id`
  1. INTEGER
  2. NOT NULL = true
  3. REFERENCES ring(id)

- **狀態選項1** `record.ring_choice_id_1`
  1. INTEGER
  2. NOT NULL = true
  3. REFERENCES ring(id)

- **狀態選項2** `record.ring_choice_id_2`
  1. INTEGER
  2. NOT NULL = true
  3. REFERENCES ring(id)

- **狀態選項3** `record.ring_choice_id_3`
  1. INTEGER
  2. NOT NULL = true
  3. REFERENCES ring(id)

- **敵人id** `record.enemy_id`
  1. INTEGER
  2. NOT NULL = true

- **敵人裝備** `record.enemy_equipment_id`
  1. INTEGER
  2. NOT NULL = true
  3. REFERENCES equipment(id)

- **敵人技能** `record.enemy_skill_id`
  1. INTEGER
  2. NOT NULL = true
  3. REFERENCES skill(id)

**主鍵：** (`game_id`, `battle_id`)

## 角色資料填寫區 actor

| id | name         | element | health | attack_point | magic_point | attack_defence | magic_defence | level |
|----|--------------|---------|--------|--------------|-------------|----------------|---------------|-------|
| 01 | "火之冒險者" | "火"  | 1000   | 100          | 100         | 5              | 5             | 0     |
| 02 | "水之冒險者" | "水" | 1000   | 100          | 100         | 5              | 5             | 0     |
| 03 | "草之冒險者" | "草" | 1000   | 100          | 100         | 5              | 5             | 0     |
| 04 | "光之冒險者" | "光" | 1000   | 100          | 100         | 5              | 5             | 0     |
| 05 | "暗之冒險者" | "暗"  | 1000   | 100          | 100         | 5              | 5             | 0     |
| 06 | "哥布林"     | "火"  | 800    | 80           | 80          | 2              | 1             | 1     |
| 07 | "史萊姆"     | "水" | 1200   | 50           | 50          | 6              | 6             | 1     |
| 08 | "精靈"       | "光" | 600    | 110          | 110         | 1              | 2             | 1     |
| 09 | "飛蟲"       | "草" | 700    | 90           | 60          | 3              | 2             | 1     |
| 10 | "亡靈"       | "暗"  | 900    | 70           | 120         | 2              | 4             | 1     |

---

## 招式資料填寫區 skill

## 技能資料表（合併後）

| id  | name       | element | power | cooldown | level | is_magic |
|-----|------------|---------|-------|----------|-------|----------|
| 01  | "燒斬擊"   | "火"    | 1.0   | 1        | 0     | 0        |
| 02  | "燒射擊"   | "火"    | 1.0   | 1        | 0     | 1        |
| 03  | "噴斬擊"   | "水"    | 1.0   | 1        | 0     | 0        |
| 04  | "噴射擊"   | "水"    | 1.0   | 1        | 0     | 1        |
| 05  | "種斬擊"   | "草"    | 1.0   | 1        | 0     | 0        |
| 06  | "種射擊"   | "草"    | 1.0   | 1        | 0     | 1        |
| 07  | "照斬擊"   | "光"    | 1.0   | 1        | 0     | 0        |
| 08  | "照射擊"   | "光"    | 1.0   | 1        | 0     | 1        |
| 09  | "遮斬擊"   | "暗"    | 1.0   | 1        | 0     | 0        |
| 10  | "遮射擊"   | "暗"    | 1.0   | 1        | 0     | 1        |
| 11  | "熾焰擊"   | "火"    | 1.2   | 2        | 1     | 0        |
| 12  | "烈焰彈"   | "火"    | 1.0   | 1        | 1     | 1        |
| 13  | "水刃旋斬" | "水"    | 1.1   | 2        | 1     | 0        |
| 14  | "冰霧束"   | "水"    | 1.1   | 2        | 1     | 1        |
| 15  | "藤條捆綁" | "草"    | 1.0   | 2        | 1     | 0        |
| 16  | "毒葉爆"   | "草"    | 1.2   | 3        | 1     | 1        |
| 17  | "閃光拳"   | "光"    | 1.0   | 1        | 1     | 0        |
| 18  | "聖光柱"   | "光"    | 1.3   | 3        | 1     | 1        |
| 19  | "暗影切"   | "暗"    | 1.0   | 2        | 1     | 0        |
| 20  | "闇爆波"   | "暗"    | 1.1   | 2        | 1     | 1        |

---

## 屬性資料填寫區 element

| name     | advantage |
|----------|-----------|
| "火"   | "草"   |
| "水"  | "火"    |
| "草"  | "水"    |
| "光"  | "暗"    |
| "暗"   | "光"   |

---

## 裝備資料填寫區 equipment

| id | name       | attack_defence | magic_defence | level |
|----|------------|----------------|----------------|--------|
| 01 | "木盾"     | 5              | 0              | 1      |
| 02 | "屏障"     | 0              | 5              | 1      |
| 03 | "黏液"     | 1              | 1              | 1      |
| 04 | "厚布甲"   | 3              | 1              | 1      |
| 05 | "輕皮甲"   | 2              | 2              | 1      |
| 06 | "魔法披風" | 0              | 6              | 1      |
| 07 | "骨製護手" | 4              | 0              | 1      |
| 08 | "藤甲"     | 2              | 3              | 1      |
| 09 | "水膜護盾" | 1              | 4              | 1      |
| 10 | "小鐵盾"   | 6              | 0              | 1      |

## 狀態資料填寫區 ring

| id  | name       | attack_power | magic_power | attack_defence | magic_defence | health | level |
|-----|------------|--------------|-------------|----------------|---------------|--------|-------|
| 01  | 熾熱強化   | +0.20        | -0.10       | 0.00           | 0.00          | 0.00   | 1     |
| 02  | 靜謐心流   | -0.05        | +0.25       | 0.00           | 0.00          | 0.00   | 1     |
| 03  | 祈禱之環   | -0.10        | 0.00        | +0.10          | +0.10         | +0.20  | 1     |
| 04  | 機率爆震   | +0.30        | 0.00        | -0.15          | -0.10         | 0.00   | 1     |
| 05  | 光速界面   | +0.10        | +0.10       | -0.05          | -0.05         | 0.00   | 1     |
| 06  | 共感場域   | +0.05        | +0.05       | +0.05          | +0.05         | +0.05  | 1     |
| 07  | 龍鱗共鳴   | -0.10        | -0.10       | +0.30          | +0.30         | 0.00   | 1     |
| 08  | 深淵契約   | +0.40        | 0.00        | -0.25          | -0.25         | -0.10  | 1     |
| 09  | 靈盾波動   | 0.00         | +0.15       | 0.00           | +0.25         | -0.05  | 1     |
| 10  | 血氣喚醒   | +0.20        | 0.00        | 0.00           | 0.00          | +0.20  | 1     |
| 11  | 撕裂意志   | +0.60        | -0.30       | -0.20          | 0.00          | 0.00   | 2     |
| 12  | 靈識滲透   | -0.20        | +0.55       | 0.00           | -0.25         | 0.00   | 2     |
| 13  | 鎧甲迴響   | -0.30        | -0.30       | +0.35          | +0.35         | +0.30  | 2     |
| 14  | 詛咒瘋化   | +0.45        | 0.00        | -0.40          | -0.40         | -0.20  | 2     |
| 15  | 永恆殘響   | -0.10        | -0.10       | 0.00           | 0.00          | +0.60  | 2     |
