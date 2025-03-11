-- phpMyAdmin SQL Dump
-- version 4.6.6
-- https://www.phpmyadmin.net/
--
-- 主機: localhost
-- 產生時間： 2025-03-11 01:02:14
-- 伺服器版本: 5.7.17-log
-- PHP 版本： 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `course`
--

-- --------------------------------------------------------

--
-- 資料表結構 `course`
--

CREATE TABLE `course` (
  `course_id` varchar(7) NOT NULL,
  `title` varchar(50) NOT NULL,
  `dept_name` varchar(20) NOT NULL,
  `credits` decimal(2,0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `course`
--

INSERT INTO `course` (`course_id`, `title`, `dept_name`, `credits`) VALUES
('BIO-101', 'Intro. to Biology', 'Biology', '4.00'),
('BIO-301', 'Genetics', 'Biology', '4.00'),
('BIO-399', 'Computational Biology', 'Biology', '3.00'),
('CS-101', 'Intro. to Computer Science', 'Comp. Sci.', '4.00'),
('CS-190', 'Game Design', 'Comp. Sci.', '4.00'),
('CS-315', 'Robotics', 'Comp. Sci.', '3.00'),
('CS-319', 'Image Processing', 'Comp. Sci.', '3.00'),
('CS-347', 'Database System Concepts', 'Comp. Sci.', '3.00'),
('EE-181', 'Intro. to Digital Systems', 'Elec. Eng.', '3.00'),
('FIN-201', 'Investment Banking', 'Finance', '3.00'),
('HIS-351', 'World History', 'History', '3.00'),
('MU-199', 'Music Video Production', 'Music', '3.00'),
('PHY-101', 'Physical Principles', 'Physics', '4.00');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
