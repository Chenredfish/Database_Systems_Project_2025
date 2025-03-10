-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主機： 127.0.0.1
-- 產生時間： 2025-03-10 12:44:14
-- 伺服器版本： 5.7.17-log
-- PHP 版本： 5.6.30


SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `20250310`
--

-- --------------------------------------------------------

--
-- 資料表結構 `teaches`
--

CREATE TABLE `teaches` (
  `ID` varchar(5) DEFAULT NULL,
  `course_id` varchar(8) DEFAULT NULL,
  `sec_id` varchar(8) DEFAULT NULL,
  `semester` varchar(6) DEFAULT NULL,
  `year` decimal(4,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `teaches`
--

INSERT INTO `teaches` (`ID`, `course_id`, `sec_id`, `semester`, `year`) VALUES
('10101', 'CS-101', '1', 'Fall', 2009),
('10101', 'CS-101', '1', 'Spring', 2010),
('10101', 'CS-315', '1', 'Fall', 2009),
('12121', 'CS-347', '1', 'Spring', 2010),
('15151', 'FIN-201', '1', 'Spring', 2010),
('22222', 'MU-199', '1', 'Fall', 2009),
('32343', 'PHY-101', '1', 'Fall', 2009),
('45565', 'HIS-351', '1', 'Spring', 2010),
('45565', 'CS-101', '1', 'Spring', 2010),
('76766', 'CS-319', '1', 'Spring', 2009),
('76766', 'BIO-101', '1', 'Summer', 2010),
('76766', 'BIO-301', '1', 'Spring', 2009),
('83821', 'CS-190', '1', 'Spring', 2009),
('83821', 'CS-190', '2', 'Spring', 2009),
('83821', 'CS-319', '2', 'Spring', 2010),
('98345', 'EE-181', '1', 'Spring', 2009);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
