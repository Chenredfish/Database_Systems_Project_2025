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
  - *Actor Attribute (Fire/Water/Grass/Thunder) (Foreign Key)*

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
  - *Skill Attribute (Fire/Water/Grass/Thunder)*

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


## 角色資料填寫區actor

| id | name | element | health | attack_point | magic_point | attack_defence | magic_defence | level |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Aiden | "Fire" | 1151 | 147 | 145 | 13 | 7 | 8 |
| 2 | Liam | "Light" | 1118 | 103 | 123 | 12 | 5 | 4 |
| 3 | Noah | "Dark" | 1342 | 101 | 150 | 18 | 8 | 4 |
| 4 | Elijah | "Thunder" | 1307 | 123 | 112 | 5 | 19 | 7 |
| 5 | Lucas | "Fire" | 1344 | 145 | 136 | 14 | 18 | 7 |
| 6 | Logan | "Water" | 1143 | 134 | 122 | 18 | 7 | 9 |
| 7 | Mason | "Water" | 1113 | 111 | 146 | 17 | 17 | 8 |
| 8 | Ethan | "Fire" | 1101 | 147 | 136 | 11 | 10 | 3 |

## 招式資料填寫區skill

| id | name | element | power | cooldown | level | is_magic |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Fire Slash | "Light" | 1.37 | 5 | 5 | 0 |
| 2 | Aqua Burst | "Thunder" | 1.85 | 5 | 1 | 1 |
| 3 | Leaf Storm | "Thunder" | 1.69 | 1 | 6 | 0 |
| 4 | Thunder Clap | "Fire" | 1.6 | 5 | 4 | 0 |
| 5 | Holy Strike | "Grass" | 1.3 | 4 | 5 | 0 |
| 6 | Shadow Pierce | "Grass" | 1.58 | 0 | 4 | 1 |
| 7 | Blaze Wheel | "Dark" | 1.71 | 4 | 6 | 0 |
| 8 | Ice Fang | "Water" | 1.48 | 0 | 6 | 0 |
| 9 | Nature Bind | "Grass" | 1.79 | 1 | 1 | 1 |
| 10 | Dark Nova | "Light" | 1.66 | 0 | 10 | 1 |

## 裝備資料填寫區equipment

| id | name | attack_defence | magic_defence | level |
| --- | --- | --- | --- | --- |
| 1 | Iron Armor | 8 | 3 | 1 |
| 2 | Mystic Cloak | 7 | 15 | 9 |
| 3 | Steel Shield | 0 | 1 | 7 |

## 屬性資料填寫區element

| name | advantage | disadvantage |
| --- | --- | --- |
| "Fire" | "Grass" | "Water" |
| "Water" | "Fire" | "Thunder" |
| "Grass" | "Water" | "Fire" |
| "Thunder" | "Water" | "Grass" |
| "Light" | "Dark" | "Dark" |
| "Dark" | "Light" | "Light" |

## 狀態資料填寫區ring

| id | name | attack_power | magic_power | attack_defence | magic_defence | health | level |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Ring of Flame | 5 | 10 | 1 | 0 | 17 | 10 |
| 2 | Aqua Ring | 10 | 3 | 4 | 0 | 34 | 9 |
| 3 | Gaia Band | 0 | 5 | 3 | 7 | 15 | 4 |
| 4 | Storm Loop | 2 | 1 | 2 | 8 | 17 | 5 |
| 5 | Halo Ring | 8 | 2 | 5 | 10 | 28 | 9 |
| 6 | Void Circle | 9 | 2 | 9 | 2 | 38 | 9 |
| 7 | Inferno Gem | 7 | 2 | 5 | 10 | 17 | 8 |
| 8 | Frost Charm | 10 | 4 | 5 | 3 | 40 | 1 |
| 9 | Earth Pendant | 3 | 5 | 1 | 8 | 19 | 7 |
| 10 | Night Seal | 8 | 9 | 6 | 7 | 35 | 7 |
