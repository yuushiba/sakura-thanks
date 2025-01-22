-- MySQL dump 10.13  Distrib 8.0.40, for Linux (aarch64)
--
-- Host: localhost    Database: sakura_thanks_development
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ar_internal_metadata`
--

DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ar_internal_metadata`
--

LOCK TABLES `ar_internal_metadata` WRITE;
/*!40000 ALTER TABLE `ar_internal_metadata` DISABLE KEYS */;
INSERT INTO `ar_internal_metadata` VALUES ('environment','development','2025-01-13 08:03:14.376483','2025-01-13 08:03:14.376485');
/*!40000 ALTER TABLE `ar_internal_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `content` text,
  `text_on_image` varchar(255) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_posts_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_5b5ddfd518` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (1,'ゆうの投稿1','ゆうの1番目の投稿内容です。',NULL,1,'2025-01-21 10:36:02.161045','2025-01-21 10:36:02.161045');
INSERT INTO `posts` VALUES (2,'ゆうの投稿2','ゆうの2番目の投稿内容です。',NULL,1,'2025-01-21 10:36:02.173393','2025-01-21 10:36:02.173393');
INSERT INTO `posts` VALUES (3,'テストユーザー1の投稿1','テストユーザー1の1番目の投稿内容です。',NULL,2,'2025-01-21 10:36:02.182031','2025-01-21 10:36:02.182031');
INSERT INTO `posts` VALUES (4,'テストユーザー1の投稿2','テストユーザー1の2番目の投稿内容です。',NULL,2,'2025-01-21 10:36:02.198304','2025-01-21 10:36:02.198304');
INSERT INTO `posts` VALUES (5,'テストユーザー2の投稿1','テストユーザー2の1番目の投稿内容です。',NULL,3,'2025-01-21 10:36:02.201754','2025-01-21 10:36:02.201754');
INSERT INTO `posts` VALUES (6,'テストユーザー2の投稿2','テストユーザー2の2番目の投稿内容です。',NULL,3,'2025-01-21 10:36:02.206515','2025-01-21 10:36:02.206515');
INSERT INTO `posts` VALUES (7,'テストユーザー3の投稿1','テストユーザー3の1番目の投稿内容です。',NULL,4,'2025-01-21 10:36:02.214290','2025-01-21 10:36:02.214290');
INSERT INTO `posts` VALUES (8,'テストユーザー3の投稿2','テストユーザー3の2番目の投稿内容です。',NULL,4,'2025-01-21 10:36:02.218744','2025-01-21 10:36:02.218744');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20250113080239');
INSERT INTO `schema_migrations` VALUES ('20250119113042');
INSERT INTO `schema_migrations` VALUES ('20250121094126');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tasks` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `crypted_password` varchar(255) DEFAULT NULL,
  `salt` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'ゆう','shiba@gmail.com','$2a$10$Vp6mQnJn165Ntcm8rWKJouZzJ8Gh/8yp8mW18/R.0PmDUvZWVYdqO','r7D1JXSQ9h1nxjK3o5JP','2025-01-20 11:27:49.209091','2025-01-20 11:27:49.209091');
INSERT INTO `users` VALUES (2,'テストユーザー1','test1@example.com','$2a$10$Y6AtmwjxSnWcJQIZPGZ4DOigboxQhiLJfRyy8r/5pKksgNsAq2Bdy','z7LzJUzFFqw-Twkf1BTE','2025-01-21 10:36:01.941345','2025-01-21 10:36:01.941345');
INSERT INTO `users` VALUES (3,'テストユーザー2','test2@example.com','$2a$10$w5/zk16mY2tiSy.v6oWAuuFL/qHYyQ4yzcv/eMcLdx.QbEVHWxpP2','xPwWQXXc4psqTry2si-3','2025-01-21 10:36:02.036546','2025-01-21 10:36:02.036546');
INSERT INTO `users` VALUES (4,'テストユーザー3','test3@example.com','$2a$10$Du9rQx6v.0If3.6fgI4iTe9QAng7H4lEf8vUjqn0.myIJdbT61Koy','v28QDGfRZoZUV-TYyKfF','2025-01-21 10:36:02.124734','2025-01-21 10:36:02.124734');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-21 22:06:07
