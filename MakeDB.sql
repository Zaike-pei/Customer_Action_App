
/******************************************************************************/
/* 対象データベース：customer_action                                          */
/*                                                                            */
/* システムで使用するテーブル                                                 */
/*                   tbl_customer      （顧客情報テーブル）                   */
/*                   tbl_staff         （スタッフマスターテーブル）           */
/*                   tbl_company       （会社マスターテーブル）               */
/*                   tbl_action        （営業報告履歴テーブル）               */
/*                   tbl_staff_backup  （スタッフマスター バックアップ用）    */
/******************************************************************************/

/****************************************/
/* 対象データベースの指定               */
/****************************************/
use [master]
GO

/****************************************/
/* 実行者の権限チェック                 */
/****************************************/
-- 変数定義
DECLARE @SRsysadmin int , @SRdbcreator int

-- 実行者が、管理者権限またはデータベースの作成者以外は実行できない
-- 現在のユーザーが sysadmin または dbcreator のメンバーであるかどうかを確認する
SELECT @SRsysadmin=IS_SRVROLEMEMBER('sysadmin')
SELECT @SRdbcreator=IS_SRVROLEMEMBER( 'dbcreator' )

IF @SRsysadmin=0 AND @SRdbcreator=0
    -- いずれのメンバーでもないとき
    BEGIN
        -- RAISERRORで127を指定してOSQLを強制終了する
        RAISERROR( 'データベース作成の権限がありません。処理を終了します',16,127)
        RETURN
    END

/****************************************/
/* customer_action データベースの作成   */
/****************************************/
-- すでに customer_action データベースが存在する場合は削除する
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'customer_action')
	DROP DATABASE [customer_action]

-- データベースの作成
CREATE DATABASE [customer_action]
PRINT '    customer_action データベースを作成しました'
GO

/****************************************/
/* 対象データベースの指定               */
/****************************************/
USE [customer_action]
GO

/****************************************/
/* 既存テーブルの削除                   */
/* 存在する場合には削除する             */
/****************************************/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_action]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_action]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_company]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_company]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_customer]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_customer]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_staff]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_staff]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_staff_backup]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_staff_backup]
GO

/****************************************/
/* テーブルの作成                       */
/****************************************/
CREATE TABLE [dbo].[tbl_action](
	[ID] [int] NOT NULL,
	[customerID] [int] NOT NULL,
	[action_date] [datetime] NOT NULL,
	[action_content] [nvarchar](400) COLLATE Japanese_CI_AS NULL,
	[action_staffID] [int] NULL,
 CONSTRAINT [PK_tbl_action] PRIMARY KEY CLUSTERED 
(
	[ID] 
)WITH  FILLFACTOR = 90  ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_company](
	[companyID] [int] NOT NULL,
	[company_name] [nvarchar](100) COLLATE Japanese_CI_AS NOT NULL,
	[company_kana] [nvarchar](100) COLLATE Japanese_CI_AS NULL,
	[delete_flag] [bit] NULL,
 CONSTRAINT [PK_tbl_company] PRIMARY KEY CLUSTERED 
(
	[companyID] 
)WITH  FILLFACTOR = 90  ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_customer](
	[customerID] [int] NOT NULL,
	[customer_name] [nvarchar](20) COLLATE Japanese_CI_AS NOT NULL,
	[customer_kana] [nvarchar](20) COLLATE Japanese_CI_AS NOT NULL,
	[companyID] [int] NULL,
	[section] [nvarchar](50) COLLATE Japanese_CI_AS NULL,
	[post] [nvarchar](30) COLLATE Japanese_CI_AS NULL,
	[zipcode] [nvarchar](8) COLLATE Japanese_CI_AS NULL,
	[address] [nvarchar](100) COLLATE Japanese_CI_AS NULL,
	[tel] [nvarchar](20) COLLATE Japanese_CI_AS NULL,
	[staffID] [int] NULL,
	[first_action_date] [datetime] NULL,
	[memo] [nvarchar](max) COLLATE Japanese_CI_AS NULL,
	[input_date] [datetime] NULL,
	[input_staff_name] [nvarchar](20) COLLATE Japanese_CI_AS NULL,
	[update_date] [datetime] NULL,
	[update_staff_name] [nvarchar](20) COLLATE Japanese_CI_AS NULL,
	[delete_flag] [bit] NULL,
 CONSTRAINT [PK_tbl_customer] PRIMARY KEY CLUSTERED 
(
	[customerID] 
)WITH  FILLFACTOR = 90  ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_staff](
	[staffID] [int] NOT NULL,
	[staff_name] [nvarchar](20) COLLATE Japanese_CI_AS NOT NULL,
	[userID] [nvarchar](10) COLLATE Japanese_CI_AS NULL,
	[password] [nvarchar](10) COLLATE Japanese_CI_AS NULL,
	[admin_flag] [bit] NULL,
	[delete_flag] [bit] NULL,
 CONSTRAINT [PK_tbl_staff] PRIMARY KEY CLUSTERED 
(
	[staffID] 
)WITH  FILLFACTOR = 90  ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_staff_backup](
	[staffID] [int] NOT NULL,
	[staff_name] [nvarchar](20) COLLATE Japanese_CI_AS NOT NULL,
	[userID] [nvarchar](10) COLLATE Japanese_CI_AS NULL,
	[password] [nvarchar](10) COLLATE Japanese_CI_AS NULL,
	[admin_flag] [bit] NULL,
	[delete_flag] [bit] NULL,
 CONSTRAINT [PK_tbl_staff_backup] PRIMARY KEY CLUSTERED 
(
	[staffID] 
)WITH  FILLFACTOR = 90  ON [PRIMARY]
) ON [PRIMARY]
GO

PRINT '    customer_action データベースに 5つのテーブルを作成しました'
GO

/****************************************/
/* サンプルデータの追加                 */
/****************************************/
SET NOCOUNT ON

-- 既存データの削除（全テーブル）
DELETE FROM tbl_customer
DELETE FROM tbl_staff
DELETE FROM tbl_company
DELETE FROM tbl_action
GO

PRINT ''
PRINT '    customer_action データベースにサンプルデータを追加します。'
GO

PRINT ''
PRINT '        tbl_customer のデータを作成します。'
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(1, N'橋本　XX至', N'ハシモト　XXシ', 1, N'アプリケーションソフトウェア事業本部', Null, '000-0000', N'東京都千代田区九段南XX-XX-XXX', '03-0000-1111', 1, '2016/12/17 00:00:00', N'・是非とも顧客として獲得したい。
・最重要の顧客
・ご挨拶時、好感触', '2017/01/01 00:00:00', N'古賀', '2018/09/01 00:00:00', N'古賀', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(2, N'貫井　XX一', N'ヌクイ　XXイチ', 2, N'システムグループ', N'主任', '000-0000', N'東京都立川市錦町XX-XX-XXX', '0425-00-1111', 6, '2017/05/15 00:00:00', Null, '2017/06/01 00:00:00', N'小川', '2018/09/01 00:00:00', N'小川', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(3, N'久保山　XX聡', N'クボヤマ　XXソウ', 3, N'システム事業推進部', Null, '000-0000', N'東京都文京区本郷XX-XX-XXX', '03-0000-1111', 1, '2017/07/17 00:00:00', Null, '2017/08/01 00:00:00', N'古賀', '2018/09/01 00:00:00', N'古賀', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(4, N'山下　XX茂', N'ヤマシタ　XXシゲ', 3, N'システム事業部　システムインテグレーション部', N'取締役', '000-0000', N'鹿児島県鹿児島市桜ヶ丘XX-XX-XXX', '099-000-1111', 6, '2017/09/17 00:00:00', Null, '2017/10/01 00:00:00', N'小川', '2018/09/01 00:00:00', N'小川', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(5, N'山下　XX輔', N'ヤマシタ　XXスケ', 9, N'ソリューション事業部', N'部長', '000-0000', N'東京都千代田区九段北XX-XX-XXX', '03-0000-1111', 1, '2017/12/26 00:00:00', Null, '2018/01/10 00:00:00', N'古賀', '2018/09/01 00:00:00', N'古賀', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(6, N'田所　XX治', N'タドコロ　XXジ', 15, N'テレマーケティング事業部', Null, '000-0000', N'東京都豊島区東XX-XX-XXX', '03-0000-1111', 9, '2017/12/27 00:00:00', Null, '2018/01/11 00:00:00', N'大下', '2018/09/01 00:00:00', N'大下', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(7, N'若狭　XX悟', N'ワカサ　XXゴ', 15, N'ネットワーク業務部　第６グループ', N'プランナー', '000-0000', N'東京都千代田区麹町XX-XX-XXX', '03-0000-1111', 8, '2018/06/18 00:00:00', Null, '2018/07/01 00:00:00', N'但馬', '2018/09/01 00:00:00', N'但馬', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(8, N'大原　XX子', N'オオハラ　XXコ', 17, N'ビジネス推進室', N'部長代理', '000-0000', N'東京都港区南青山XX-XX-XXX', '03-0000-1111', 4, '2018/07/17 00:00:00', Null, '2018/08/01 00:00:00', N'山本', '2018/09/01 00:00:00', N'山本', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(9, N'針生　XX一', N'ハリオ　XXイチ', 11, N'マルチメディア事業部', Null, '000-0000', N'東京都渋谷区宇田川町XX-XX-XXX', '03-0000-1111', 11, '2018/07/17 00:00:00', Null, '2018/08/01 00:00:00', N'高山', '2018/09/01 00:00:00', N'高山', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(10, N'青山　XX春', N'アオヤマ　XXハル', 9, N'メディア推進本部', N'専務取締役', '000-0000', N'東京都渋谷区宇田川町XX-XX-XXX', '03-0000-1111', 5, '2018/07/17 00:00:00', Null, '2018/08/01 00:00:00', N'坂下', '2018/09/01 00:00:00', N'坂下', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(11, N'富士井　XX雄', N'フジイ　XXオ', 13, N'営業開発部', N'担当部長', '000-0000', N'東京都豊島区東池袋XX-XX-XXX', '03-0000-1111', 4, '2018/08/18 00:00:00', Null, '2018/09/01 00:00:00', N'山本', '2018/09/01 00:00:00', N'山本', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(12, N'染井　XX己', N'ソメイ　XXミ', 17, N'営業部', Null, '000-0000', N'茨城県水海道市豊岡町乙XX-XX-XXX', '0297-00-1111', 7, '2018/09/17 00:00:00', Null, '2018/10/01 00:00:00', N'香山', '2018/09/01 00:00:00', N'香山', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(13, N'池内　XX徹', N'イケウチ　XXテツ', 16, N'企画制作部　企画制作課', Null, '000-0000', N'東京都渋谷区代々木XX-XX-XXX', '03-0000-1111', 16, '2018/10/18 00:00:00', Null, '2018/11/01 00:00:00', N'坂本', '2018/09/01 00:00:00', N'坂本', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(14, N'黒澤　XX二', N'クロサワ　XXジ', 12, N'企画調整部', N'室長', '000-0000', N'東京都港区赤坂XX-XX-XXX', '03-0000-1111', 2, '2018/12/17 00:00:00', Null, '2019/01/01 00:00:00', N'木島', '2018/09/01 00:00:00', N'木島', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(15, N'西出　XX美', N'ニシイデ　XXミ', 17, N'業務グループ', N'担当課長', '000-0000', N'東京都中野区江原町XX-XX-XXX', '03-0000-1111', 16, '2019/01/18 00:00:00', Null, '2019/02/01 00:00:00', N'坂本', '2018/09/01 00:00:00', N'坂本', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(16, N'赤羽橋　XX渉', N'アカバネバシ　XXホ', 9, N'商品企画部', Null, '000-0000', N'東京都墨田区文花XX-XX-XXX', '03-0000-1111', 7, '2016/04/18 00:00:00', Null, '2016/05/01 00:00:00', N'香山', '2018/09/01 00:00:00', N'香山', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(17, N'大期　XX子', N'オオキ　XXコ', 9, N'情報システム部', Null, '000-0000', N'東京都港区赤坂XX-XX-XXX', '03-0000-1111', 1, '2016/05/16 00:00:00', Null, '2016/06/01 00:00:00', N'古賀', '2018/09/01 00:00:00', N'古賀', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(18, N'大田　XX夫', N'オオタ　XXオ', 7, N'新製品開発事業部', Null, '000-0000', N'東京都文京区本郷XX-XX-XXX', '03-0000-1111', 9, '2016/05/16 00:00:00', Null, '2016/06/01 00:00:00', N'大下', '2018/09/01 00:00:00', N'大下', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(19, N'中村　XX視', N'ナカムラ　XXミ', 8, N'人事システム事業推進部', Null, '000-0000', N'東京都中央区新川XX-XX-XXX', '03-0000-1111', 7, '2016/11/18 00:00:00', Null, '2016/12/01 00:00:00', N'香山', '2018/09/01 00:00:00', N'香山', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(20, N'亀田　XX男', N'カメダ　XXオ', 9, N'人事本部　人材課', N'課長補佐', '000-0000', N'東京都品川区北品川XX-XX-XXX', '03-0000-1111', 3, '2016/11/18 00:00:00', Null, '2016/12/01 00:00:00', N'中川', '2018/09/01 00:00:00', N'中川', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(21, N'桜貝　XX夫', N'サクラガイ　XXオ', 10, N'生産管理部', Null, '000-0000', N'東京都渋谷区広尾XX-XX-XXX', '03-0000-1111', 7, '2016/12/17 00:00:00', Null, '2017/01/01 00:00:00', N'香山', '2018/09/01 00:00:00', N'香山', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(22, N'松本　XX夫', N'マツモト　XXオ', 5, Null, N'代表取締役', '000-0000', N'愛知県稲沢市菱町XX-XX-XXX', '0587-00-1111', 16, '2016/12/17 00:00:00', Null, '2017/01/01 00:00:00', N'坂本', '2018/09/01 00:00:00', N'坂本', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(23, N'小橋　XX之', N'コバシ　XXユキ', 2, N'第四編集部', Null, '000-0000', N'静岡県富士市中央町XX-XX-XXX', '0545-00-1111', 1, '2017/01/18 00:00:00', Null, '2017/02/01 00:00:00', N'古賀', '2018/09/01 00:00:00', N'古賀', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(24, N'大河原　XX子', N'オオガワラ　XXコ', 15, N'東京営業一部　新宿支店', N'支店長', '000-0000', N'東京都豊島区池袋XX-XX-XXX', '03-0000-1111', 6, '2017/09/17 00:00:00', Null, '2017/10/01 00:00:00', N'小川', '2018/09/01 00:00:00', N'小川', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(25, N'材寄　XX毅', N'ザイヨリ　XXキ', 4, N'営業部', Null, '000-0000', N'東京都港区北青山XX-XX-XXX', '03-0000-1111', 1, '2017/11/18 00:00:00', Null, '2017/12/01 00:00:00', N'古賀', '2018/09/01 00:00:00', N'古賀', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(26, N'飯田　XX枝', N'イイダ　XXエ', 17, N'企画制作部　企画制作課', N'課長代理', '000-0000', N'東京都豊島区東池袋XX-XX-XXX', '03-0000-1111', 14, '2018/06/18 00:00:00', Null, '2018/07/01 00:00:00', N'青島', '2018/09/01 00:00:00', N'青島', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(27, N'田岡　XX信', N'タオカ　XXノブ', 16, N'企画調整部', Null, '000-0000', N'東京都渋谷区笹塚XX-XX-XXX', '03-0000-1111', 8, '2018/11/18 00:00:00', Null, '2018/12/01 00:00:00', N'但馬', '2018/09/01 00:00:00', N'但馬', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(28, N'諸兄　XX徹', N'モロエ　XXテツ', 11, N'営業部', Null, '000-0000', N'東京都千代田区麹町XX-XX-XXX', '03-0000-1111', 1, '2019/01/18 00:00:00', Null, '2019/02/01 00:00:00', N'古賀', '2018/09/01 00:00:00', N'古賀', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(29, N'百舌　XX則', N'モズ　XXノリ', 16, N'総務部', Null, '000-0000', N'石川県能美郡辰口町旭台XX-XX-XXX', '0761-00-1111', 1, '2016/09/17 00:00:00', Null, '2016/10/01 00:00:00', N'古賀', '2018/09/01 00:00:00', N'古賀', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(30, N'村松　XX子', N'ムラマツ　XXコ', 16, N'総務部', Null, '000-0000', N'東京都港区東新橋XX-XX-XXX', '03-0000-1111', 5, '2016/09/17 00:00:00', Null, '2016/10/01 00:00:00', N'坂下', '2018/09/01 00:00:00', N'坂下', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(31, N'山形　XX雄', N'ヤマガタ　XXオ', 15, N'総務部', Null, '000-0000', N'東京都豊島区西池袋XX-XX-XXX', '03-0000-1111', Null, '2017/06/18 00:00:00', Null, '2017/07/01 00:00:00', N'大下', '2018/09/01 00:00:00', N'大下', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(32, N'土方　XX美', N'ヒジカタ　XXミ', 12, N'総務部', Null, '000-0000', N'東京都渋谷区宇田川町XX-XX-XXX', '03-0000-1111', 4, '2017/09/17 00:00:00', Null, '2017/10/01 00:00:00', N'山本', '2018/09/01 00:00:00', N'山本', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(33, N'赤阪　XX治', N'アカサカ　XXハル', 11, N'情報システム部', N'部長', '000-0000', N'神奈川県横浜市中区野毛町XX-XX-XXX', '045-000-1111', 15, '2017/09/17 00:00:00', Null, '2017/10/01 00:00:00', N'韮崎', '2018/09/01 00:00:00', N'韮崎', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(34, N'金山　XX文', N'カナヤマ　XXフミ', 4, N'情報システム部', Null, '000-0000', N'東京都中央区日本橋小船町XX-XX-XXX', '03-0000-1111', 8, '2017/10/18 00:00:00', Null, '2017/11/01 00:00:00', N'但馬', '2018/09/01 00:00:00', N'但馬', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(35, N'藤木　XX明', N'フジキ　XXアキ', 9, N'情報システム部', N'課長', '000-0000', N'東京都中野区東中野XX-XX-XXX', '03-0000-1111', Null, '2017/10/18 00:00:00', Null, '2017/11/01 00:00:00', N'坂本', '2018/09/01 00:00:00', N'坂本', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(36, N'針生　XX男', N'ハリオ　XXオ', 13, N'営業部', Null, '000-0000', N'東京都新宿区西新宿XX-XX-XXX', '03-0000-1111', 13, '2017/11/18 00:00:00', Null, '2017/12/01 00:00:00', N'柳沢', '2018/09/01 00:00:00', N'柳沢', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(37, N'大石　XX澄', N'オオイシ　XXスミ', 5, N'総務部', Null, '000-0000', N'東京都豊島区南池袋XX-XX-XXX', '03-0000-1111', 16, '2017/12/17 00:00:00', Null, '2018/01/01 00:00:00', N'坂本', '2018/09/01 00:00:00', N'坂本', 0)
INSERT INTO tbl_customer ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag])
    VALUES(38, N'谷藤　XX行', N'タニフジ　XXユキ', 8, N'企画調整部', Null, '000-0000', N'東京都文京区本郷XX-XX-XXX', '03-0000-1111', 1, '2018/01/18 00:00:00', Null, '2018/02/01 00:00:00', N'古賀', '2018/09/01 00:00:00', N'古賀', 0)
PRINT '        tbl_customer に 38 件のデータを追加しました。'
GO


PRINT ''
PRINT '        tbl_staff のデータを作成します。'
INSERT INTO tbl_staff ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag])
    VALUES(1, N'古賀', 'koga', 'a0022', 1, 0)
INSERT INTO tbl_staff ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag])
    VALUES(2, N'木島', 'kijima', 'b2468', 0, 0)
INSERT INTO tbl_staff ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag])
    VALUES(3, N'中川', 'nakagawa', 'c4429', 0, 0)
INSERT INTO tbl_staff ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag])
    VALUES(4, N'山本', 'yamamoto', 'b7435', 0, 0)
INSERT INTO tbl_staff ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag])
    VALUES(5, N'坂下', 'sakasita', 'c7833', 0, 0)
INSERT INTO tbl_staff ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag])
    VALUES(6, N'小川', 'ogawa', 'b8765', 1, 0)
INSERT INTO tbl_staff ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag])
    VALUES(7, N'香山', 'kouyama', 'd2389', 0, 0)
INSERT INTO tbl_staff ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag])
    VALUES(8, N'但馬', 'tajima', 'a2927', 0, 0)
INSERT INTO tbl_staff ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag])
    VALUES(9, N'大下', 'ooshita', 'a3327', 0, 0)
INSERT INTO tbl_staff ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag])
    VALUES(10, N'大森', 'oomori', 'b3812', 1, 0)
INSERT INTO tbl_staff ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag])
    VALUES(11, N'高山', 'takayama', 'b2389', 0, 0)
INSERT INTO tbl_staff ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag])
    VALUES(12, N'飯島', 'iijima', 'a5644', 1, 0)
INSERT INTO tbl_staff ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag])
    VALUES(13, N'柳沢', 'yagisita', 'a7196', 0, 0)
INSERT INTO tbl_staff ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag])
    VALUES(14, N'青島', 'aoshima', 'a0016', 0, 0)
INSERT INTO tbl_staff ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag])
    VALUES(15, N'韮崎', 'nirasaki', 'b0023', 1, 0)
INSERT INTO tbl_staff ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag])
    VALUES(16, N'坂本', 'sakamoto', 'b0046', 0, 0)
PRINT '        tbl_staff に 16 件のデータを追加しました。'
GO


PRINT ''
PRINT '        tbl_company のデータを作成します。'
INSERT INTO tbl_company ([companyID], [company_name], [company_kana], [delete_flag])
    VALUES(1, N'株式会社百面相△□', N'ヒャクメンソウ△□', 0)
INSERT INTO tbl_company ([companyID], [company_name], [company_kana], [delete_flag])
    VALUES(2, N'ググッド◎◇株式会社', N'ググッド◎◇', 0)
INSERT INTO tbl_company ([companyID], [company_name], [company_kana], [delete_flag])
    VALUES(3, N'株式会社パル×○', N'パル×○', 0)
INSERT INTO tbl_company ([companyID], [company_name], [company_kana], [delete_flag])
    VALUES(4, N'クレソン●×株式会社', N'クレソン●×', 0)
INSERT INTO tbl_company ([companyID], [company_name], [company_kana], [delete_flag])
    VALUES(5, N'株式会社ABC産業○◎', N'ＡＢＣサンギョウ○◎', 0)
INSERT INTO tbl_company ([companyID], [company_name], [company_kana], [delete_flag])
    VALUES(6, N'ABC電気商会◇○株式会社', N'ＡＢＣデンキショウカイ◇○', 0)
INSERT INTO tbl_company ([companyID], [company_name], [company_kana], [delete_flag])
    VALUES(7, N'アールシーエフ□●開発株式会社', N'アールシーエフ□●カイハツ', 0)
INSERT INTO tbl_company ([companyID], [company_name], [company_kana], [delete_flag])
    VALUES(8, N'株式会社マイクロコンピュータ▼◎', N'マイクロコンピュータ▼◎', 0)
INSERT INTO tbl_company ([companyID], [company_name], [company_kana], [delete_flag])
    VALUES(9, N'株式会社マイクロファイン▼×', N'マイクロファイン▼×', 0)
INSERT INTO tbl_company ([companyID], [company_name], [company_kana], [delete_flag])
    VALUES(10, N'新世紀開発×□株式会社', N'シンセイキカイハツ×□', 0)
INSERT INTO tbl_company ([companyID], [company_name], [company_kana], [delete_flag])
    VALUES(11, N'CIAC□▼株式会社', N'ＣＩＡＣ□▼', 0)
INSERT INTO tbl_company ([companyID], [company_name], [company_kana], [delete_flag])
    VALUES(12, N'株式会社書籍出版△□企画', N'ショセキシュッパン△□キカク', 0)
INSERT INTO tbl_company ([companyID], [company_name], [company_kana], [delete_flag])
    VALUES(13, N'みずかめ◎×株式会社', N'ミズカメ◎×', 0)
INSERT INTO tbl_company ([companyID], [company_name], [company_kana], [delete_flag])
    VALUES(14, N'株式会社富士山電鉄●△', N'フジサンデンテツ●△', 0)
INSERT INTO tbl_company ([companyID], [company_name], [company_kana], [delete_flag])
    VALUES(15, N'ファインビビット△●株式会社', N'ファインビビット△●', 0)
INSERT INTO tbl_company ([companyID], [company_name], [company_kana], [delete_flag])
    VALUES(16, N'ペルソナソフト△×株式会社', N'ペルソナソフト△×', 0)
INSERT INTO tbl_company ([companyID], [company_name], [company_kana], [delete_flag])
    VALUES(17, N'株式会社キャリア支援□◎', N'キャリアシエン□◎', 0)
PRINT '        tbl_company に 17 件のデータを追加しました。'
GO


PRINT ''
PRINT '        tbl_action のデータを作成します。'
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(1, 22, '2018/07/23 00:00:00', N'顧客22_アクション001', 15)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(2, 12, '2018/07/23 00:00:00', N'顧客12_アクション001', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(3, 37, '2018/07/25 00:00:00', N'顧客37_アクション001', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(4, 14, '2018/07/25 00:00:00', N'顧客14_アクション001', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(5, 38, '2018/07/25 00:00:00', N'顧客38_アクション001', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(6, 38, '2018/07/25 00:00:00', N'顧客38_アクション002', 11)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(7, 7, '2018/07/26 00:00:00', N'顧客07_アクション001', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(8, 21, '2018/07/27 00:00:00', N'顧客21_アクション001', 9)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(9, 18, '2018/07/27 00:00:00', N'顧客18_アクション001', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(10, 14, '2018/07/27 00:00:00', N'顧客14_アクション002', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(11, 32, '2018/07/28 00:00:00', N'顧客32_アクション001', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(12, 32, '2018/07/29 00:00:00', N'顧客32_アクション002', 15)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(13, 13, '2018/07/30 00:00:00', N'顧客13_アクション001', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(14, 27, '2018/07/30 00:00:00', N'顧客27_アクション001', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(15, 12, '2018/07/30 00:00:00', N'顧客12_アクション002', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(16, 27, '2018/07/30 00:00:00', N'顧客27_アクション002', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(17, 4, '2018/07/30 00:00:00', N'顧客04_アクション001', 14)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(18, 1, '2018/07/30 00:00:00', N'顧客01_アクション001', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(19, 27, '2018/07/30 00:00:00', N'顧客27_アクション003', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(20, 14, '2018/07/31 00:00:00', N'顧客14_アクション003', 16)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(21, 6, '2018/07/31 00:00:00', N'顧客06_アクション001', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(22, 9, '2018/07/31 00:00:00', N'顧客09_アクション001', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(23, 13, '2018/07/31 00:00:00', N'顧客13_アクション002', 16)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(24, 23, '2018/07/31 00:00:00', N'顧客23_アクション001', 13)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(25, 24, '2018/07/31 00:00:00', N'顧客24_アクション001', 16)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(26, 6, '2018/07/31 00:00:00', N'顧客06_アクション002', 14)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(27, 31, '2018/08/01 00:00:00', N'顧客31_アクション001', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(28, 9, '2018/08/01 00:00:00', N'顧客09_アクション002', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(29, 18, '2018/08/01 00:00:00', N'顧客18_アクション002', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(30, 3, '2018/08/02 00:00:00', N'顧客03_アクション001', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(31, 9, '2018/08/02 00:00:00', N'顧客09_アクション003', 16)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(32, 7, '2018/08/03 00:00:00', N'顧客07_アクション002', 1)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(33, 22, '2018/08/04 00:00:00', N'顧客22_アクション002', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(34, 10, '2018/08/04 00:00:00', N'顧客10_アクション001', 16)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(35, 4, '2018/08/05 00:00:00', N'顧客04_アクション002', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(36, 37, '2018/08/05 00:00:00', N'顧客37_アクション002', 16)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(37, 28, '2018/08/06 00:00:00', N'顧客28_アクション001', 13)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(38, 28, '2018/08/06 00:00:00', N'顧客28_アクション002', 16)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(39, 35, '2018/08/07 00:00:00', N'顧客35_アクション001', 15)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(40, 29, '2018/08/07 00:00:00', N'顧客29_アクション001', 16)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(41, 30, '2018/08/09 00:00:00', N'顧客30_アクション001', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(42, 27, '2018/08/09 00:00:00', N'顧客27_アクション004', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(43, 27, '2018/08/09 00:00:00', N'顧客27_アクション005', 14)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(44, 23, '2018/08/09 00:00:00', N'顧客23_アクション002', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(45, 4, '2018/08/10 00:00:00', N'顧客04_アクション003', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(46, 14, '2018/08/10 00:00:00', N'顧客14_アクション004', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(47, 27, '2018/08/10 00:00:00', N'顧客27_アクション006', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(48, 15, '2018/08/11 00:00:00', N'顧客15_アクション001', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(49, 15, '2018/08/11 00:00:00', N'顧客15_アクション002', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(50, 18, '2018/08/12 00:00:00', N'顧客18_アクション003', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(51, 25, '2018/08/13 00:00:00', N'顧客25_アクション001', 1)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(52, 33, '2018/08/15 00:00:00', N'顧客33_アクション001', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(53, 21, '2018/08/15 00:00:00', N'顧客21_アクション002', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(54, 30, '2018/08/15 00:00:00', N'顧客30_アクション002', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(55, 2, '2018/08/15 00:00:00', N'顧客02_アクション001', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(56, 10, '2018/08/15 00:00:00', N'顧客10_アクション002', 15)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(57, 25, '2018/08/15 00:00:00', N'顧客25_アクション002', 9)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(58, 37, '2018/08/15 00:00:00', N'顧客37_アクション003', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(59, 33, '2018/08/15 00:00:00', N'顧客33_アクション002', 16)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(60, 34, '2018/08/15 00:00:00', N'顧客34_アクション001', 13)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(61, 10, '2018/08/15 00:00:00', N'顧客10_アクション003', 9)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(62, 9, '2018/08/15 00:00:00', N'顧客09_アクション004', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(63, 23, '2018/08/15 00:00:00', N'顧客23_アクション003', 15)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(64, 9, '2018/08/15 00:00:00', N'顧客09_アクション005', 13)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(65, 24, '2018/08/18 00:00:00', N'顧客24_アクション002', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(66, 11, '2018/08/18 00:00:00', N'顧客11_アクション001', 13)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(67, 34, '2018/08/18 00:00:00', N'顧客34_アクション002', 15)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(68, 5, '2018/08/18 00:00:00', N'顧客05_アクション001', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(69, 36, '2018/08/18 00:00:00', N'顧客36_アクション001', 16)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(70, 4, '2018/08/19 00:00:00', N'顧客04_アクション004', 14)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(71, 15, '2018/08/20 00:00:00', N'顧客15_アクション003', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(72, 38, '2018/08/20 00:00:00', N'顧客38_アクション003', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(73, 2, '2018/08/20 00:00:00', N'顧客02_アクション002', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(74, 8, '2018/08/21 00:00:00', N'顧客08_アクション001', 14)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(75, 10, '2018/08/21 00:00:00', N'顧客10_アクション004', 15)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(76, 26, '2018/08/22 00:00:00', N'顧客26_アクション011', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(77, 30, '2018/08/22 00:00:00', N'顧客30_アクション003', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(78, 33, '2018/08/22 00:00:00', N'顧客33_アクション003', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(79, 9, '2018/08/22 00:00:00', N'顧客09_アクション006', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(80, 22, '2018/08/23 00:00:00', N'顧客22_アクション003', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(81, 4, '2018/08/24 00:00:00', N'顧客04_アクション005', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(82, 11, '2018/08/24 00:00:00', N'顧客11_アクション002', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(83, 36, '2018/08/25 00:00:00', N'顧客36_アクション002', 1)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(84, 14, '2018/08/25 00:00:00', N'顧客14_アクション005', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(85, 13, '2018/08/25 00:00:00', N'顧客13_アクション003', 1)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(86, 15, '2018/08/25 00:00:00', N'顧客15_アクション004', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(87, 34, '2018/08/25 00:00:00', N'顧客34_アクション003', 13)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(88, 16, '2018/08/25 00:00:00', N'顧客16_アクション001', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(89, 33, '2018/08/26 00:00:00', N'顧客33_アクション004', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(90, 14, '2018/08/26 00:00:00', N'顧客14_アクション006', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(91, 35, '2018/08/26 00:00:00', N'顧客35_アクション002', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(92, 16, '2018/08/27 00:00:00', N'顧客16_アクション002', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(93, 13, '2018/08/27 00:00:00', N'顧客13_アクション004', 14)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(94, 16, '2018/08/27 00:00:00', N'顧客16_アクション003', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(95, 33, '2018/08/28 00:00:00', N'顧客33_アクション005', 15)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(96, 3, '2018/08/28 00:00:00', N'顧客03_アクション002', 14)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(97, 8, '2018/08/28 00:00:00', N'顧客08_アクション002', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(98, 16, '2018/08/29 00:00:00', N'顧客16_アクション004', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(99, 27, '2018/08/29 00:00:00', N'顧客27_アクション007', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(100, 19, '2018/08/29 00:00:00', N'顧客19_アクション001', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(101, 21, '2018/08/29 00:00:00', N'顧客21_アクション003', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(102, 31, '2018/08/29 00:00:00', N'顧客31_アクション002', 11)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(103, 23, '2018/08/29 00:00:00', N'顧客23_アクション004', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(104, 8, '2018/08/30 00:00:00', N'顧客08_アクション003', 9)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(105, 37, '2018/08/30 00:00:00', N'顧客37_アクション004', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(106, 27, '2018/08/30 00:00:00', N'顧客27_アクション008', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(107, 32, '2018/08/30 00:00:00', N'顧客32_アクション003', 1)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(108, 19, '2018/08/30 00:00:00', N'顧客19_アクション002', 13)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(109, 36, '2018/08/31 00:00:00', N'顧客36_アクション003', 15)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(110, 17, '2018/08/31 00:00:00', N'顧客17_アクション001', 13)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(111, 32, '2018/08/31 00:00:00', N'顧客32_アクション004', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(112, 13, '2018/09/01 00:00:00', N'顧客13_アクション005', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(113, 34, '2018/09/01 00:00:00', N'顧客34_アクション004', 1)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(114, 31, '2018/09/01 00:00:00', N'顧客31_アクション003', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(115, 9, '2018/09/01 00:00:00', N'顧客09_アクション007', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(116, 32, '2018/09/01 00:00:00', N'顧客32_アクション005', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(117, 1, '2018/09/02 00:00:00', N'顧客01_アクション002', 11)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(118, 16, '2018/09/02 00:00:00', N'顧客16_アクション005', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(119, 28, '2018/09/02 00:00:00', N'顧客28_アクション003', 16)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(120, 32, '2018/09/02 00:00:00', N'顧客32_アクション006', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(121, 28, '2018/09/03 00:00:00', N'顧客28_アクション004', 9)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(122, 10, '2018/09/03 00:00:00', N'顧客10_アクション005', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(123, 26, '2018/09/04 00:00:00', N'顧客26_アクション012', 11)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(124, 37, '2018/09/04 00:00:00', N'顧客37_アクション005', 14)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(125, 27, '2018/09/04 00:00:00', N'顧客27_アクション009', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(126, 38, '2018/09/05 00:00:00', N'顧客38_アクション004', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(127, 31, '2018/09/06 00:00:00', N'顧客31_アクション004', 11)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(128, 29, '2018/09/07 00:00:00', N'顧客29_アクション002', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(129, 15, '2018/09/07 00:00:00', N'顧客15_アクション005', 1)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(130, 29, '2018/09/08 00:00:00', N'顧客29_アクション003', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(131, 8, '2018/09/08 00:00:00', N'顧客08_アクション004', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(132, 23, '2018/09/08 00:00:00', N'顧客23_アクション005', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(133, 16, '2018/09/08 00:00:00', N'顧客16_アクション006', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(134, 25, '2018/09/08 00:00:00', N'顧客25_アクション003', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(135, 9, '2018/09/08 00:00:00', N'顧客09_アクション008', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(136, 35, '2018/09/09 00:00:00', N'顧客35_アクション003', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(137, 25, '2018/09/09 00:00:00', N'顧客25_アクション004', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(138, 14, '2018/09/09 00:00:00', N'顧客14_アクション007', 15)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(139, 31, '2018/09/10 00:00:00', N'顧客31_アクション005', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(140, 2, '2018/09/11 00:00:00', N'顧客02_アクション003', 1)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(141, 14, '2018/09/11 00:00:00', N'顧客14_アクション008', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(142, 31, '2018/09/11 00:00:00', N'顧客31_アクション006', 14)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(143, 36, '2018/09/11 00:00:00', N'顧客36_アクション004', 1)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(144, 27, '2018/09/12 00:00:00', N'顧客27_アクション010', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(145, 17, '2018/09/12 00:00:00', N'顧客17_アクション002', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(146, 21, '2018/09/12 00:00:00', N'顧客21_アクション004', 13)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(147, 24, '2018/09/12 00:00:00', N'顧客24_アクション003', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(148, 14, '2018/09/13 00:00:00', N'顧客14_アクション009', 11)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(149, 9, '2018/09/14 00:00:00', N'顧客09_アクション009', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(150, 37, '2018/09/14 00:00:00', N'顧客37_アクション006', 15)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(151, 31, '2018/09/14 00:00:00', N'顧客31_アクション007', 14)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(152, 12, '2018/09/14 00:00:00', N'顧客12_アクション003', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(153, 2, '2018/09/14 00:00:00', N'顧客02_アクション004', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(154, 30, '2018/09/15 00:00:00', N'顧客30_アクション004', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(155, 24, '2018/09/15 00:00:00', N'顧客24_アクション004', 11)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(156, 20, '2018/09/15 00:00:00', N'顧客20_アクション001', 14)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(157, 12, '2018/09/15 00:00:00', N'顧客12_アクション004', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(158, 30, '2018/09/16 00:00:00', N'顧客30_アクション005', 14)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(159, 5, '2018/09/16 00:00:00', N'顧客05_アクション002', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(160, 10, '2018/09/16 00:00:00', N'顧客10_アクション006', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(161, 20, '2018/09/16 00:00:00', N'顧客20_アクション002', 1)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(162, 25, '2018/09/17 00:00:00', N'顧客25_アクション005', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(163, 12, '2018/09/18 00:00:00', N'顧客12_アクション005', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(164, 7, '2018/09/18 00:00:00', N'顧客07_アクション003', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(165, 23, '2018/09/19 00:00:00', N'顧客23_アクション006', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(166, 34, '2018/09/19 00:00:00', N'顧客34_アクション005', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(167, 37, '2018/09/19 00:00:00', N'顧客37_アクション007', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(168, 33, '2018/09/20 00:00:00', N'顧客33_アクション006', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(169, 7, '2018/09/20 00:00:00', N'顧客07_アクション004', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(170, 1, '2018/09/20 00:00:00', N'顧客01_アクション003', 16)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(171, 18, '2018/09/20 00:00:00', N'顧客18_アクション004', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(172, 8, '2018/09/21 00:00:00', N'顧客08_アクション005', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(173, 10, '2018/09/24 00:00:00', N'顧客10_アクション007', 1)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(174, 12, '2018/09/24 00:00:00', N'顧客12_アクション006', 9)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(175, 22, '2018/09/24 00:00:00', N'顧客22_アクション004', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(176, 32, '2018/09/24 00:00:00', N'顧客32_アクション007', 11)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(177, 9, '2018/09/25 00:00:00', N'顧客09_アクション010', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(178, 34, '2018/09/25 00:00:00', N'顧客34_アクション006', 11)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(179, 19, '2018/09/25 00:00:00', N'顧客19_アクション003', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(180, 28, '2018/09/25 00:00:00', N'顧客28_アクション005', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(181, 18, '2018/09/25 00:00:00', N'顧客18_アクション005', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(182, 27, '2018/09/26 00:00:00', N'顧客27_アクション011', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(183, 34, '2018/09/28 00:00:00', N'顧客34_アクション007', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(184, 25, '2018/09/28 00:00:00', N'顧客25_アクション006', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(185, 10, '2018/09/28 00:00:00', N'顧客10_アクション008', 9)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(186, 10, '2018/09/28 00:00:00', N'顧客10_アクション009', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(187, 20, '2018/09/29 00:00:00', N'顧客20_アクション003', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(188, 4, '2018/09/29 00:00:00', N'顧客04_アクション006', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(189, 28, '2018/09/29 00:00:00', N'顧客28_アクション006', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(190, 28, '2018/09/29 00:00:00', N'顧客28_アクション007', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(191, 15, '2018/09/29 00:00:00', N'顧客15_アクション006', 15)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(192, 21, '2018/09/30 00:00:00', N'顧客21_アクション005', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(193, 10, '2018/09/30 00:00:00', N'顧客10_アクション010', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(194, 24, '2018/09/30 00:00:00', N'顧客24_アクション005', 1)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(195, 32, '2018/09/30 00:00:00', N'顧客32_アクション008', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(196, 30, '2018/09/30 00:00:00', N'顧客30_アクション006', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(197, 2, '2018/10/01 00:00:00', N'顧客02_アクション005', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(198, 14, '2018/10/01 00:00:00', N'顧客14_アクション010', 15)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(199, 14, '2018/10/01 00:00:00', N'顧客14_アクション011', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(200, 18, '2018/10/01 00:00:00', N'顧客18_アクション006', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(201, 7, '2018/10/01 00:00:00', N'顧客07_アクション005', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(202, 13, '2018/10/01 00:00:00', N'顧客13_アクション006', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(203, 9, '2018/10/02 00:00:00', N'顧客09_アクション011', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(204, 36, '2018/10/02 00:00:00', N'顧客36_アクション005', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(205, 26, '2018/10/02 00:00:00', N'顧客26_アクション013', 14)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(206, 24, '2018/10/02 00:00:00', N'顧客24_アクション006', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(207, 19, '2018/10/02 00:00:00', N'顧客19_アクション004', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(208, 13, '2018/10/03 00:00:00', N'顧客13_アクション007', 1)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(209, 27, '2018/10/03 00:00:00', N'顧客27_アクション012', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(210, 19, '2018/10/04 00:00:00', N'顧客19_アクション005', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(211, 38, '2018/10/04 00:00:00', N'顧客38_アクション005', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(212, 15, '2018/10/04 00:00:00', N'顧客15_アクション007', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(213, 12, '2018/10/05 00:00:00', N'顧客12_アクション007', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(214, 8, '2018/10/06 00:00:00', N'顧客08_アクション006', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(215, 35, '2018/10/07 00:00:00', N'顧客35_アクション004', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(216, 15, '2018/10/07 00:00:00', N'顧客15_アクション008', 15)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(217, 10, '2018/10/08 00:00:00', N'顧客10_アクション011', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(218, 8, '2018/10/08 00:00:00', N'顧客08_アクション007', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(219, 16, '2018/10/08 00:00:00', N'顧客16_アクション007', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(220, 11, '2018/10/09 00:00:00', N'顧客11_アクション003', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(221, 31, '2018/10/09 00:00:00', N'顧客31_アクション008', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(222, 16, '2018/10/09 00:00:00', N'顧客16_アクション008', 1)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(223, 15, '2018/10/09 00:00:00', N'顧客15_アクション009', 1)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(224, 31, '2018/10/09 00:00:00', N'顧客31_アクション009', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(225, 25, '2018/10/10 00:00:00', N'顧客25_アクション007', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(226, 15, '2018/10/10 00:00:00', N'顧客15_アクション010', 13)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(227, 4, '2018/10/10 00:00:00', N'顧客04_アクション007', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(228, 4, '2018/10/10 00:00:00', N'顧客04_アクション008', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(229, 21, '2018/10/10 00:00:00', N'顧客21_アクション006', 14)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(230, 19, '2018/10/11 00:00:00', N'顧客19_アクション006', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(231, 10, '2018/10/11 00:00:00', N'顧客10_アクション012', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(232, 16, '2018/10/11 00:00:00', N'顧客16_アクション009', 11)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(233, 17, '2018/10/11 00:00:00', N'顧客17_アクション003', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(234, 5, '2018/10/11 00:00:00', N'顧客05_アクション003', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(235, 25, '2018/10/11 00:00:00', N'顧客25_アクション008', 13)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(236, 20, '2018/10/12 00:00:00', N'顧客20_アクション004', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(237, 25, '2018/10/13 00:00:00', N'顧客25_アクション009', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(238, 30, '2018/10/13 00:00:00', N'顧客30_アクション007', 11)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(239, 15, '2018/10/13 00:00:00', N'顧客15_アクション011', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(240, 38, '2018/10/14 00:00:00', N'顧客38_アクション006', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(241, 6, '2018/10/14 00:00:00', N'顧客06_アクション003', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(242, 12, '2018/10/14 00:00:00', N'顧客12_アクション008', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(243, 32, '2018/10/14 00:00:00', N'顧客32_アクション009', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(244, 33, '2018/10/15 00:00:00', N'顧客33_アクション007', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(245, 36, '2018/10/15 00:00:00', N'顧客36_アクション006', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(246, 11, '2018/10/15 00:00:00', N'顧客11_アクション004', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(247, 1, '2018/10/16 00:00:00', N'顧客01_アクション004', 14)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(248, 34, '2018/10/16 00:00:00', N'顧客34_アクション008', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(249, 10, '2018/10/16 00:00:00', N'顧客10_アクション013', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(250, 29, '2018/10/16 00:00:00', N'顧客29_アクション004', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(251, 8, '2018/10/18 00:00:00', N'顧客08_アクション008', 13)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(252, 35, '2018/10/18 00:00:00', N'顧客35_アクション005', 15)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(253, 28, '2018/10/18 00:00:00', N'顧客28_アクション008', 15)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(254, 14, '2018/10/19 00:00:00', N'顧客14_アクション012', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(255, 11, '2018/10/19 00:00:00', N'顧客11_アクション005', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(256, 9, '2018/10/20 00:00:00', N'顧客09_アクション012', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(257, 9, '2018/10/20 00:00:00', N'顧客09_アクション013', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(258, 16, '2018/10/20 00:00:00', N'顧客16_アクション010', 15)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(259, 33, '2018/10/20 00:00:00', N'顧客33_アクション008', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(260, 7, '2018/10/20 00:00:00', N'顧客07_アクション006', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(261, 1, '2018/10/21 00:00:00', N'顧客01_アクション005', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(262, 21, '2018/10/21 00:00:00', N'顧客21_アクション007', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(263, 27, '2018/10/21 00:00:00', N'顧客27_アクション013', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(264, 21, '2018/10/22 00:00:00', N'顧客21_アクション008', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(265, 14, '2018/10/22 00:00:00', N'顧客14_アクション013', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(266, 30, '2018/10/22 00:00:00', N'顧客30_アクション008', 12)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(267, 27, '2018/10/22 00:00:00', N'顧客27_アクション014', 1)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(268, 18, '2018/10/22 00:00:00', N'顧客18_アクション007', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(269, 1, '2018/10/23 00:00:00', N'顧客01_アクション006', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(270, 35, '2018/10/23 00:00:00', N'顧客35_アクション006', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(271, 25, '2018/10/23 00:00:00', N'顧客25_アクション010', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(272, 31, '2018/10/23 00:00:00', N'顧客31_アクション010', 11)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(273, 26, '2018/10/23 00:00:00', N'顧客26_アクション014', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(274, 28, '2018/10/23 00:00:00', N'顧客28_アクション009', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(275, 29, '2018/10/24 00:00:00', N'顧客29_アクション005', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(276, 31, '2018/10/24 00:00:00', N'顧客31_アクション011', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(277, 14, '2018/10/24 00:00:00', N'顧客14_アクション014', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(278, 23, '2018/10/25 00:00:00', N'顧客23_アクション007', 9)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(279, 13, '2018/10/25 00:00:00', N'顧客13_アクション008', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(280, 32, '2018/10/25 00:00:00', N'顧客32_アクション010', 14)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(281, 6, '2018/10/25 00:00:00', N'顧客06_アクション004', 4)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(282, 30, '2018/10/25 00:00:00', N'顧客30_アクション009', 9)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(283, 35, '2018/10/25 00:00:00', N'顧客35_アクション007', 11)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(284, 30, '2018/10/25 00:00:00', N'顧客30_アクション010', 13)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(285, 5, '2018/10/26 00:00:00', N'顧客05_アクション004', 6)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(286, 6, '2018/10/26 00:00:00', N'顧客06_アクション005', 14)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(287, 23, '2018/10/27 00:00:00', N'顧客23_アクション008', 3)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(288, 28, '2018/10/27 00:00:00', N'顧客28_アクション010', 8)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(289, 20, '2018/10/27 00:00:00', N'顧客20_アクション005', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(290, 35, '2018/10/27 00:00:00', N'顧客35_アクション008', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(291, 33, '2018/10/28 00:00:00', N'顧客33_アクション009', 2)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(292, 29, '2018/10/28 00:00:00', N'顧客29_アクション006', 7)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(293, 2, '2018/10/28 00:00:00', N'顧客02_アクション006', 10)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(294, 17, '2018/10/28 00:00:00', N'顧客17_アクション004', 5)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(295, 17, '2018/10/28 00:00:00', N'顧客17_アクション005', 16)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(296, 11, '2018/10/28 00:00:00', N'顧客11_アクション006', 15)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(297, 10, '2018/10/29 00:00:00', N'顧客10_アクション014', 9)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(298, 30, '2018/10/29 00:00:00', N'顧客30_アクション011', 1)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(299, 7, '2018/10/30 00:00:00', N'顧客07_アクション007', 14)
INSERT INTO tbl_action ([ID], [customerID], [action_date], [action_content], [action_staffID])
    VALUES(300, 37, '2018/10/30 00:00:00', N'顧客37_アクション008', 10)
PRINT '        tbl_action に 300 件のデータを追加しました。'
GO


/****************************************/
/* 既存のビューの削除                   */
/* 存在する場合には削除する             */
/****************************************/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vw_customer_view]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[vw_customer_view]
GO

/****************************************/
/* ビューの作成                         */
/****************************************/
CREATE VIEW [dbo].[vw_customer_view]
AS
SELECT                  dbo.tbl_customer.*, ISNULL(dbo.tbl_company.company_name, '') AS company_name, dbo.tbl_company.company_kana, dbo.tbl_staff.staff_name
FROM                     dbo.tbl_customer LEFT OUTER JOIN
                                  dbo.tbl_company ON dbo.tbl_customer.companyID = dbo.tbl_company.companyID LEFT OUTER JOIN
                                  dbo.tbl_staff ON dbo.tbl_customer.staffID = dbo.tbl_staff.staffID
WHERE                   (dbo.tbl_customer.delete_flag = 0)
GO

PRINT ''
PRINT '    customer_action データベースに vw_customer_view ビューを追加しました'
GO
