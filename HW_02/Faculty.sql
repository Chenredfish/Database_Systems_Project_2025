-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主機： localhost
-- 產生時間： 2025 年 03 月 28 日 11:08
-- 伺服器版本： 10.4.28-MariaDB
-- PHP 版本： 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 資料庫： `20250325`
--

-- --------------------------------------------------------

--
-- 資料表結構 `Faculty`
--

CREATE TABLE `Faculty` (
  `FacSSN` char(11) NOT NULL,
  `FacFirstName` varchar(50) NOT NULL,
  `FacLastName` varchar(50) NOT NULL,
  `FacCity` varchar(50) NOT NULL,
  `FacState` char(2) NOT NULL,
  `FacZipCode` char(10) NOT NULL,
  `FacHireDate` date DEFAULT NULL,
  `FacDept` char(6) DEFAULT NULL,
  `FacRank` char(4) DEFAULT NULL,
  `FacSalary` decimal(10,2) DEFAULT NULL,
  `FacSupervisor` char(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- 傾印資料表的資料 `Faculty`
--

INSERT INTO `Faculty` (`FacSSN`, `FacFirstName`, `FacLastName`, `FacCity`, `FacState`, `FacZipCode`, `FacHireDate`, `FacDept`, `FacRank`, `FacSalary`, `FacSupervisor`) VALUES
('098-76-5432', 'LEONARD', 'VINCE', 'SEATTLE', 'WA', '98111-9921', '1995-04-10', 'MS', 'ASST', 35000.00, '654-32-1098'),
('543-21-0987', 'VICTORIA', 'EMMANUEL', 'BOTHELL', 'WA', '98011-2242', '1996-04-15', 'MS', 'PROF', 120000.00, NULL),
('654-32-1098', 'LEONARD', 'FIBON', 'SEATTLE', 'WA', '98121-0094', '1994-05-01', 'MS', 'ASSC', 70000.00, '543-21-0987'),
('765-43-2109', 'NICKI', 'MACON', 'BELLEVUE', 'WA', '98015-9945', '1997-04-11', 'FIN', 'PROF', 65000.00, NULL),
('876-54-3210', 'CRISTOPHER', 'COLAN', 'SEATTLE', 'WA', '98114-1332', '1999-03-01', 'MS', 'ASST', 40000.00, '654-32-1098'),
('987-65-4321', 'JULIA', 'MILLS', 'SEATTLE', 'WA', '98114-9954', '2000-03-15', 'FIN', 'ASSC', 75000.00, '765-43-2109');

--
-- 已傾印資料表的索引
--

--
-- 資料表索引 `Faculty`
--
ALTER TABLE `Faculty`
  ADD PRIMARY KEY (`FacSSN`),
  ADD KEY `FKFacSupervisor` (`FacSupervisor`);

--
-- 已傾印資料表的限制式
--

--
-- 資料表的限制式 `Faculty`
--
ALTER TABLE `Faculty`
  ADD CONSTRAINT `FKFacSupervisor` FOREIGN KEY (`FacSupervisor`) REFERENCES `Faculty` (`FacSSN`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
