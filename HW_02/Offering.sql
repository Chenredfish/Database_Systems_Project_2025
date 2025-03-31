-- phpMyAdmin SQL Dump
-- version 4.6.6
-- https://www.phpmyadmin.net/
--
-- 主機: localhost
-- 產生時間： 2025-03-31 08:34:10
-- 伺服器版本: 5.7.17-log
-- PHP 版本： 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `hw2`
--

-- --------------------------------------------------------

--
-- 資料表結構 `Offering`
--

CREATE TABLE `offering` (
  `OfferNo` int(11) NOT NULL,
  `CourseNo` char(6) NOT NULL,
  `OffLocation` varchar(50) NOT NULL,
  `OffDays` char(6) NOT NULL,
  `OffTerm` char(6) NOT NULL,
  `OffYear` int(11) NOT NULL,
  `FacSSN` char(11) NOT NULL,
  `OffTime` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `Offering`
--

INSERT INTO `Offering` (`OfferNo`, `CourseNo`, `OffLocation`, `OffDays`, `OffTerm`, `OffYear`, `FacSSN`, `OffTime`) VALUES
(1111, 'IS320', 'BLM302', 'MW', 'SUMMER', 2006, '', '10:30:00'),
(1234, 'IS320', 'BLM302', 'MW', 'FALL', 2005, '098-76-5432', '10:30:00'),
(2222, 'IS460', 'BLM412', 'TTH', 'SUMMER', 2005, '', '13:30:00'),
(3333, 'IS320', 'BLM214', 'MW', 'SPRING', 2006, '098-76-5432', '08:30:00'),
(4321, 'IS320', 'BLM214', 'TTH', 'FALL', 2005, '098-76-5432', '15:30:00'),
(4444, 'IS320', 'BLM302', 'TTH', 'WINTER', 2006, '543-21-0987', '15:30:00'),
(5555, 'FIN300', 'BLM207', 'MW', 'WINTER', 2006, '765-43-2109', '08:30:00'),
(5678, 'IS480', 'BLM302', 'MW', 'WINTER', 2006, '987-65-4321', '10:30:00'),
(5679, 'IS480', 'BLM4', 'TTH', 'SPRING', 2006, '876-54-3210', '12:30:00'),
(6666, 'FIN450', 'BLM212', 'TTH', 'WINTER', 2006, '987-65-4321', '10:30:00'),
(7777, 'FIN480', 'BLM305', 'MW', 'SPRING', 2006, '765-43-2109', '13:30:00'),
(8888, 'IS320', 'BLM405', 'MW', 'SUMMER', 2006, '654-32-1098', '13:30:00'),
(9876, 'IS460', 'BLM307', 'TTH', 'SPRING', 2006, '654-32-1098', '13:30:00');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
