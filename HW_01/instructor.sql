-- phpMyAdmin SQL Dump
-- version 4.6.6
-- https://www.phpmyadmin.net/
--
-- 主機: localhost
-- 產生時間： 2025-03-10 12:12:39
-- 伺服器版本: 5.7.17-log
-- PHP 版本： 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `20250304`
--

-- --------------------------------------------------------

--
-- 資料表結構 `instructor`
--

CREATE TABLE `instructor` (
  `ID` varchar(5) NOT NULL,
  `name` varchar(20) NOT NULL,
  `dept_name` varchar(20) NOT NULL,
  `salary` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `instructor`
--

INSERT INTO `instructor` (`ID`, `name`, `dept_name`, `salary`) VALUES
('22222', 'Einstein', 'Physics', '95000.00'),
('12121', 'Wu', 'Finance', '90000.00'),
('32343', 'El Said', 'History', '60000.00'),
('45565', 'Katz', 'Comp.Sci.', '75000.00'),
('98345', 'Kim', 'Elec.Eng.', '80000.00'),
('76766', 'Crick', 'Biology', '72000.00'),
('10101', 'Srinivasan', 'Comp.Sci.', '65000.00'),
('58583', 'Califieri', 'History', '62000.00'),
('83821', 'Brandt', 'Comp.Sci.', '92000.00'),
('15151', 'Mozart', 'Music', '40000.00'),
('33456', 'Gold', 'Physics', '87000.00'),
('76543', 'Singh', 'Finance', '80000.00');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
