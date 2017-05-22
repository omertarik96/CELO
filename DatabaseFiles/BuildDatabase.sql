DROP TABLE Questions;
DROP TABLE QuestionTypes;
DROP TABLE CourseContent;
DROP TABLE SectionUsers;
DROP TABLE Sections;
DROP TABLE Courses;
DROP TABLE CourseStatus;
DROP TABLE UserSessions;
DROP TABLE Invitation;
DROP TABLE InvitationReasons;
DROP TABLE Users;
DROP TABLE AnswerableQuestions;
DROP TABLE AnswerableQuestionsGroups;
DROP TABLE AnsweredQuestions;
DROP TABLE AnsweringQuestionsGroup;
DROP TABLE AssessmentQuestions;
DROP TABLE Assessments;
DROP TABLE CourseContentChildren;
DROP TABLE CourseContentTemplates;
DROP TABLE CourseContentTest;
DROP TABLE Files;
DROP TABLE Numbers;
DROP TABLE QuestionsBackup;
DROP TABLE QuestionsPool;
DROP TABLE QuestionsPoolUsers;
DROP TABLE RunningAssessments;
DROP TABLE Tags;





/**************************************************************************/
/* Users                                                                  */
/**************************************************************************/
DROP TABLE Users;
CREATE TABLE Users
(
  UserID varchar(36),
  FirstName VARCHAR(200),
  LastName VARCHAR(200),
  Email VARCHAR(200),
  PhoneNumber VARCHAR(200),
  UserName VARCHAR(200) NOT NULL,
  Password VARCHAR(200) NOT NULL,
  Role VARCHAR(50) NOT NULL CHECK(Role IN ('Admin','Instructor','TA','Student')),
  UHID CHAR(7),
  Properties TEXT,
  PRIMARY KEY(UserID)
) ENGINE=innodb;


/**************************************************************************/
/* User Sessions                                                          */
/**************************************************************************/
DROP TABLE UserSessions;
CREATE TABLE UserSessions
(
  SessionID varchar(36),
  UserID varchar(36),
  TimeLastAccessed TIMESTAMP,
  MAC_Address VARCHAR(300),
  Role VARCHAR(50),
  PRIMARY KEY(SessionID),
  FOREIGN KEY(UserID) REFERENCES Users(UserID) ON DELETE CASCADE
) ENGINE=innodb;

/**************************************************************************/
/* Questions                                                              */
/* We want to have a question pool that holds these questions             */
/**************************************************************************/
DROP TABLE QuestionsPool;
CREATE TABLE QuestionsPool
(
  QuestionsPoolID BIGINT NOT NULL AUTO_INCREMENT,
  ParentQuestionPool BIGINT,
  UserID VARCHAR(36),
  Name VARCHAR(200),
  Description VARCHAR(200),
  Parameters TEXT,
  PRIMARY KEY(QuestionsPoolID),
  FOREIGN KEY(UserID) REFERENCES Users(UserID) ON DELETE CASCADE

);
ALTER TABLE QuestionsPool MODIFY COLUMN ParentQuestionPool BIGINT  NULL,
  ADD CONSTRAINT fk_QuestionsPool FOREIGN KEY(ParentQuestionPool) REFERENCES QuestionsPool(QuestionsPoolID);



DROP TABLE QuestionsPoolUsers;
SET FOREIGN_KEY_CHECKS = 0;
CREATE TABLE QuestionsPoolUsers
(
  QuestionsPoolID BIGINT,
  UserID VARCHAR(36) NOT NULL,
  AddedOn DATETIME,
  Privilege VARCHAR(100),
  PRIMARY KEY (QuestionsPoolID,UserID),
  FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
) ENGINE=innodb;

DROP TABLE Questions;

SET FOREIGN_KEY_CHECKS = 0;
CREATE TABLE Questions
(
  QuestionID BIGINT(20) NOT NULL AUTO_INCREMENT,
  QuestionType VARCHAR(200),
  Question VARCHAR(1000),
  ExpectedAnswer VARCHAR(1000),
  CreatedBy VARCHAR(36),
  JSONParameters TEXT,
  QuestionsPoolID BIGINT NOT NULL,
  PRIMARY KEY(QuestionID),
  FOREIGN KEY(CreatedBy) REFERENCES Users(UserID),
  FOREIGN KEY(QuestionsPoolID) REFERENCES QuestionsPool(QuestionsPoolID) ON DELETE CASCADE
) ENGINE=innodb;
/**************************************************************************/
/* Course                                                                */
/**************************************************************************/
DROP TABLE Courses;
CREATE TABLE Courses
(
  CourseUniqueID BIGINT AUTO_INCREMENT NOT NULL ,
  CourseName VARCHAR(100),
  CourseCategory CHAR(4),
  Setup BOOL,
  CourseID INTEGER,
  Description VARCHAR(500),
  CourseStatus VARCHAR(200),
  CreatedBy VARCHAR(36),
  Properties TEXT,
  PRIMARY KEY(CourseUniqueID),
  FOREIGN KEY(CreatedBy) REFERENCES Users(UserID)
) ENGINE=innodb;


/**************************************************************************/
/* Section                                                                */
/**************************************************************************/
DROP TABLE Sections;
CREATE TABLE Sections
(
  SectionID BIGINT UNIQUE AUTO_INCREMENT NOT NULL ,
  SectionNumber INTEGER,
  StartDate DATETIME,
  EndDate DATETIME,
  Location VARCHAR(200),
  TextBookInformation VARCHAR(500),
  CourseUniqueID BIGINT,
  CreatedBy VARCHAR(36),
  MainCourseContentID BIGINT,
  Properties TEXT,
  PRIMARY KEY(SectionID),
  FOREIGN KEY(CourseUniqueID) REFERENCES Courses(CourseUniqueID) ON DELETE CASCADE,
  FOREIGN KEY(MainCourseContentID) REFERENCES CourseContent(ContentID) ON DELETE CASCADE

) ENGINE=innodb;

DELETE FROM Courses;
/**************************************************************************/
/* Section Users                                                          */
/**************************************************************************/
DROP TABLE SectionUsers;
CREATE TABLE SectionUsers
(
  SectionUsersID BIGINT AUTO_INCREMENT,
  SectionID BIGINT,
  AddedOn DATETIME,
  AssignedBy VARCHAR(36),
  UserID VARCHAR(36),
  UHID INT(7),

  PRIMARY KEY(SectionUsersID),
  FOREIGN KEY(SectionID) REFERENCES Sections(SectionID) ON DELETE CASCADE,
  FOREIGN KEY(UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
  FOREIGN KEY(AssignedBy) REFERENCES Users(UserID) ON  DELETE CASCADE
) ENGINE=innodb;
/**************************************************************************/
/* Invitation Reasons                                                     */
/**************************************************************************/
DROP TABLE InvitationReasons;
CREATE TABLE InvitationReasons
(
  ReasonID VARCHAR(10),
  ReasonString VARCHAR(200),
  RolesExcepted VARCHAR(200),
  PRIMARY KEY (ReasonID)
) ENGINE=innodb;

/**************************************************************************/
/* Invitation                                                             */
/**************************************************************************/
DROP TABLE Invitation;
CREATE TABLE Invitation
(
  InvitationID varchar(36),
  Accepted BOOL,
  Viewed BOOL,
  InvitedBy VARCHAR(36),
  Inviting VARCHAR(36),
  ReasonID VARCHAR(10),


  PRIMARY KEY(InvitationID),
  FOREIGN KEY(Inviting) REFERENCES Users(UserID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY(InvitedBy) REFERENCES Users(UserID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY(ReasonID) REFERENCES InvitationReasons(ReasonID) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=innodb;
DROP TABLE Tags;


/**************************************************************************/
/* Section Folders                                                        */
/**************************************************************************/
DROP TABLE CourseContent;
CREATE TABLE CourseContent
(
  ContentID BIGINT NOT NULL AUTO_INCREMENT,
  CourseContentNumber BIGINT ,
  SectionID BIGINT NOT NULL,
  Name VARCHAR(200),
  URL VARCHAR(200),
  Description VARCHAR(1000),
  ParentFolderID BIGINT,
  RootContentID BIGINT,
  Depth INTEGER,
  Type VARCHAR(200),
  Properties TEXT,
  Gradable BOOL,
  CreatedBy VARCHAR(36),
  RolesVisible VARCHAR(200), /* Role1|Role2|Role3 */


  PRIMARY KEY(CourseContentNumber,SectionID),
  FOREIGN KEY(CreatedBy) REFERENCES Users(UserID) ON  DELETE CASCADE

) ENGINE=innodb;

ALTER TABLE CourseContent DROP FOREIGN KEY fk_ParentFolderID;
ALTER TABLE CourseContent DROP FOREIGN KEY fk_CourseContent_ParentFolderID;
ALTER TABLE CourseContent DROP FOREIGN KEY fk_CourseContent_RootContentID;

ALTER TABLE CourseContent
  ADD CONSTRAINT fk_ParentFolderID
FOREIGN KEY(SectionID) REFERENCES Sections(SectionID) ON DELETE CASCADE;

ALTER TABLE CourseContent
  ADD CONSTRAINT fk_CourseContent_ParentFolderID
FOREIGN KEY(ParentFolderID) REFERENCES CourseContent(ContentID) ON DELETE CASCADE;

ALTER TABLE CourseContent
  ADD CONSTRAINT fk_CourseContent_RootContentID
FOREIGN KEY(RootContentID) REFERENCES CourseContent(ContentID) ON DELETE CASCADE;


/***************************************************************************/
/* Files                                                                   */
/***************************************************************************/
DROP TABLE Files;
CREATE TABLE Files(
  FileID varchar(36),
  Path VARCHAR(200),
  ContentType VARCHAR(200),
  Name VARCHAR(200),
  CreatedBy VARCHAR(36),
  FOREIGN KEY(CreatedBy) REFERENCES Users(UserID),
  PRIMARY KEY(FileID)
) ENGINE=innodb;


DROP TABLE CourseContentTemplates;
CREATE TABLE CourseContentTemplates
(
  TemplateID BIGINT NOT NULL AUTO_INCREMENT,
  FileID varchar(36),
  Creator          VARCHAR(36),
  Notes           TEXT,
  Name           TEXT,
  PrivacyOptions  VARCHAR(100),

  PRIMARY KEY(TemplateID),
  FOREIGN KEY (FileID) REFERENCES Files(FileID) ON DELETE CASCADE,
  FOREIGN KEY(Creator) REFERENCES Users(UserID) ON DELETE CASCADE



) ENGINE=innodb;
DROP PROCEDURE SaveAsTemplate;


/***************************************************************************/
/* Answerable Question Group                                               */
/* Holds the Basic Connections Between a collection of questions           */
/***************************************************************************/
DROP TABLE AnswerableQuestionsGroups;
CREATE TABLE AnswerableQuestionsGroups(
  AnswerableGroupID BIGINT NOT NULL AUTO_INCREMENT ,
  CreatedOn DATETIME,
  CreatedBy VARCHAR(36),
  Category VARCHAR(200),
  CourseContentID BIGINT,
  AvailableOn DATETIME,
  AvailableTo DATETIME,
  Timeallowed INTEGER,
  Modified DATETIME,
  PRIMARY KEY(AnswerableGroupID),
  FOREIGN KEY(CourseContentID) REFERENCES CourseContent(ContentID) ON DELETE CASCADE,
  FOREIGN KEY(CreatedBy) REFERENCES Users(UserID) ON DELETE CASCADE
  /*, FOREIGN KEY(TypeID) REFERENCES AnswerableQuestionsGroupTypes(GroupID) ON UPDATE CASCADE ON DELETE CASCADE */
) ENGINE=innodb;

DROP TABLE AnsweringQuestionsGroup;
CREATE TABLE AnsweringQuestionsGroup(
  AnsweringGroupID BIGINT NOT NULL AUTO_INCREMENT,
  AnswerableGroupID BIGINT,
  StartOn DATETIME,
  StartedBy VARCHAR(36),
  FinishedOn DATETIME,
  ExpiresOn DATETIME,
  PRIMARY KEY(AnsweringGroupID),
  FOREIGN KEY(StartedBy) REFERENCES Users(UserID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY(AnswerableGroupID) REFERENCES AnswerableQuestionsGroups(AnswerableGroupID) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=innodb;


/***************************************************************************/
/* Answerable Questions                                                    */
/* Falls Under the Answerable Questions Group. Which holds all the info for*/
/* a question that has the ability to be answered.                         */
/***************************************************************************/
DROP TABLE AnswerableQuestions;
CREATE TABLE AnswerableQuestions(
  AnswerableID BIGINT AUTO_INCREMENT,
  AnswerableGroupID BIGINT,
  QuestionID BIGINT NOT NULL,
  AllowedAttempts INTEGER,
  PointsWorth INTEGER,
  CorrectAnswer VARCHAR(200),
  PRIMARY KEY(AnswerableID,AnswerableGroupID),
  FOREIGN KEY(QuestionID) REFERENCES Questions(QuestionID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY(AnswerableGroupID) REFERENCES AnswerableQuestionsGroups(AnswerableGroupID) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=innodb;

/***************************************************************************/
/* Answered Questions                                                      */
/* Fold Under the Answerable Question. Which holds a particular response to*/
/* a answerable question                                                   */
/***************************************************************************/
DROP TABLE AnsweredQuestions;
CREATE TABLE AnsweredQuestions(
  AnswerableID BIGINT AUTO_INCREMENT ,
  AnsweredHTML TEXT,               /* Once the question is answered. The HTML that is showing will be saved */
  Attempts INTEGER,
  ChosenAnswer VARCHAR(200),
  AnsweringGroupID BIGINT,
  PRIMARY KEY(AnswerableID,AnsweringGroupID),
  FOREIGN KEY(AnswerableID) REFERENCES AnswerableQuestions(AnswerableID) ON UPDATE CASCADE ON DELETE CASCADE

) ENGINE=innodb;

DROP TRIGGER AnswerableQuestionsNumberTracker;
DELIMITER //
CREATE TRIGGER AnswerableQuestionsNumberTracker
BEFORE INSERT ON AnswerableQuestions
FOR EACH ROW
  BEGIN
    if new.AnswerableID IS NULL THEN

      SET new.AnswerableID=NULL; #(SELECT (MAX(S1.AnswerableID)+1) FROM AnswerableQuestions AS S1 WHERE S1.AnswerableGroupID=new.AnswerableGroupID);

    END IF;

  END//
DELIMITER ;
DROP TRIGGER AnsweredQuestionsNumberTracker;
DELIMITER //
CREATE TRIGGER AnsweredQuestionsNumberTracker
BEFORE INSERT ON AnsweredQuestions
FOR EACH ROW
  BEGIN
    if new.AnswerableID IS NULL THEN

        SET new.AnswerableID=(SELECT (MAX(S1.AnswerableID)+1) FROM AnsweredQuestions AS S1 WHERE S1.AnsweringGroupID=new.AnsweringGroupID);

    END IF;

  END//
DELIMITER ;

/***************************************************************************/
/* Course Content Breadcrumb Improving. We will have a trigger to keep     */
/* of children                                                             */
/***************************************************************************/
DROP TABLE CourseContentChildren;
CREATE TABLE CourseContentChildren(
  ContentID BIGINT,
  ChildContentID BIGINT,
  Depth INTEGER
) ENGINE=innodb;



/***************************************************************************/
/* Question Types. We don't want to delete this all the time. Very important*/
/***************************************************************************/
# DROP TABLE QuestionTypes
# CREATE TABLE QuestionTypes
# (
#   QuestionTypeID BIGINT NOT NULL AUTO_INCREMENT,
#   SrcDirectory VARCHAR(1000),
#   Name VARCHAR(1000),
#   CreatedBy VARCHAR(36),
#   PRIMARY KEY(QuestionTypeID),
#   FOREIGN KEY(CreatedBy) REFERENCES Users(UserID)
#
# );

/***************************************************************************/
/* Questions. We don't want to delete this all the time. Very important    */
/***************************************************************************/
# DROP TABLE Questions;
# CREATE TABLE Questions
# (
#   QuestionID BIGINT NOT NULL AUTO_INCREMENT,
#   QuestionTypeID BIGINT,
#   SrcDirectory VARCHAR(1000),
#   Question VARCHAR(1000),
#   ExpectedAnswer VARCHAR(1000),
#   CreatedBy VARCHAR(36),
#   JSONParameters TEXT,
#   PRIMARY KEY(QuestionID),
#   FOREIGN KEY (QuestionTypeID) REFERENCES QuestionTypes(QuestionTypeID),
#   FOREIGN KEY(CreatedBy) REFERENCES Users(UserID)
#
# );

/***************************************************************************/
/* Assessments                                                             */
/***************************************************************************/
DROP TABLE Assessments;
# CREATE TABLE Assessments(
#
#   AssessmentID BIGINT NOT NULL AUTO_INCREMENT,
#   Name VARCHAR(200),
#   URL VARCHAR(200),
#   Description VARCHAR(1000),
#   Type VARCHAR(200),
#   Properties TEXT,
#   AssociatedCourseContentID BIGINT NOT NULL,
#   AnswerableGroupID BIGINT,
#   CreatedBy VARCHAR(36),
#   Timelimit INTEGER,
#
#
#   PRIMARY KEY(AssessmentID),
#   FOREIGN KEY(AssociatedCourseContentID) REFERENCES CourseContent(ContentID) ON UPDATE CASCADE ON DELETE CASCADE,
#   FOREIGN KEY(AnswerableGroupID) REFERENCES AnswerableQuestionsGroups(AnswerableGroupID)ON UPDATE CASCADE ON DELETE CASCADE,
#   FOREIGN KEY(CreatedBy) REFERENCES Users(UserID) ON UPDATE CASCADE ON DELETE CASCADE
#
# ) ENGINE=innodb;

/***************************************************************************/
/* Assessment Questions                                                    */
/***************************************************************************/
DROP TABLE AssessmentQuestions;
# CREATE TABLE AssessmentQuestions(
#   AssessmentQuestionID BIGINT NOT NULL AUTO_INCREMENT ,
#   AssessmentID BIGINT NOT NULL ,
#   QuestionID BIGINT NOT NULL ,
#   Weight INTEGER,
#   AddedBy VARCHAR(36) NOT NULL,
#
#   PRIMARY KEY(AssessmentQuestionID),
#   FOREIGN KEY(AssessmentID) REFERENCES Assessments(AssessmentID) ON UPDATE CASCADE ON DELETE CASCADE,
#   FOREIGN KEY(QuestionID) REFERENCES Questions(QuestionID) ON UPDATE CASCADE ON DELETE CASCADE,
#   FOREIGN KEY(AddedBy) REFERENCES Users(AddedBy) ON UPDATE CASCADE ON DELETE CASCADE
# ) ENGINE=innodb;

/***************************************************************************/
/* Running Assessments. The User Instance of an Assessment                 */
/***************************************************************************/
DROP TABLE RunningAssessments;
# CREATE TABLE RunningAssessments(
#   AnsweredID BIGINT NOT NULL AUTO_INCREMENT,
#   AssessmentID BIGINT NOT NULL,
#   StartTime DATETIME DEFAULT NULL,
#   EndTime DATETIME DEFAULT NULL,
#   TotalPoints INTEGER,
#   EarnedPoints INTEGER,
#   AnsweringBy VARCHAR(36) NOT NULL,
#   GradedBy VARCHAR(36),
#   AnsweringGroupID BIGINT NOT NULL,
#
#
#   PRIMARY KEY(AnsweredID),
#   FOREIGN KEY(AssessmentID) REFERENCES Assessments(AssessmentID) ON UPDATE CASCADE ON DELETE CASCADE,
#   FOREIGN KEY(AnsweringBy) REFERENCES Users(UserID) ON UPDATE CASCADE ON DELETE CASCADE,
#   FOREIGN KEY(GradedBy) REFERENCES Users(GradedBy) ON UPDATE CASCADE ON DELETE CASCADE,
#   FOREIGN KEY(AnsweringGroupID) REFERENCES AnsweringQuestionsGroup(AnsweringGroupID) ON UPDATE CASCADE ON DELETE CASCADE
#
# ) ENGINE=innodb;






/*
DROP TABLE AnswerableQuestionsGroupTypes;
CREATE TABLE AnswerableQuestionsGroupTypes(
  GroupID BIGINT NOT NULL AUTO_INCREMENT ,
  Name VARCHAR(300) NOT NULL,
  AdditionalInformation TEXT NOT NULL,
  BaseGroupID BIGINT NULL,
  PRIMARY KEY(GroupID),
  FOREIGN KEY(BaseGroupID) REFERENCES AnswerableQuestionsGroupTypes(GroupID)
);


INSERT INTO AnswerableQuestionsGroupTypes (Name, AdditionalInformation, BaseGroupID)  VALUES ('Assessment',
                                                                                              'The Basis for Answering Questions in a group',
                                                                                              NULL);
INSERT INTO AnswerableQuestionsGroupTypes (Name, AdditionalInformation, BaseGroupID)  VALUES ('Magic Points',
                                                                                              'A Special Way of answering questions',
                                                                                              NULL);
INSERT INTO AnswerableQuestionsGroupTypes (Name, AdditionalInformation, BaseGroupID)  VALUES ('Quiz',
                                                                                              'A Smaller, less stressfull assessment',
                                                                                              'Assessment');
*/

/***************************************************************************/
/*                     I m p o r t a n t   T r i g g e r s                 */
/***************************************************************************/
DELIMITER //

/***************************************************************************/
/* Course Controller Children Trigger                                      */
/* A way to keep track of who is the child and who is the parent. To make  */
/* sql selects easier and faster                                           */
/***************************************************************************/
DROP TRIGGER CourseContentNumberTracker;
DELIMITER //
CREATE TRIGGER CourseContentNumberTracker
  BEFORE INSERT ON CourseContent
  FOR EACH ROW
    BEGIN
      if new.CourseContentNumber IS NULL THEN
        SET new.RootContentID=0;
        SET new.CourseContentNumber=0;
        if new.ParentFolderID is NOT NULL THEN
          SET new.CourseContentNumber=(SELECT (MAX(S1.CourseContentNumber)+1) FROM CourseContent AS S1 WHERE S1.RootContentID=new.RootContentID);
        ELSE
          SET new.RootContentID=0;
        END IF;

      END IF;

    END//
DELIMITER ;

# CREATE TRIGGER CourseContentChildren
# AFTER INSERT ON CourseContent
# FOR EACH ROW
#   BEGIN
#     DECLARE ParentID BIGINT;
#     DECLARE Depth INTEGER;
#
#     /***********************************************************************/
#     /* Get the Parent Id of this course                                    */
#     /***********************************************************************/
#     SET ParentID = new.ParentFolderID;
#     SET Depth = new.Depth;
#
#     /***********************************************************************/
#     /* Found it so now we will add it to all parents                       */
#     /***********************************************************************/
#     IF ParentID IS NOT NULL
#     THEN
#
#       INSERT INTO CourseContentChildren (ContentID, ChildContentID, Depth)
#         SELECT
#           S1.ContentID,
#           (new.ContentID)        AS ChildContentID,
#           (new.Depth - S1.Depth) AS Depth
#         FROM CourseContentChildren AS S1
#         WHERE (S1.ChildContentID = new.ParentFolderID);
#       INSERT INTO CourseContentChildren (ContentID, ChildContentID, Depth) VALUES
#         (new.ParentFolderID, new.ContentID, new.Depth);
#
#
#     END IF;
#   END//
#
#

/***************************************************************************/
/***************************************************************************/
/***************************************************************************/
CREATE VIEW `AnsweredQuestionsCombo` AS
  SELECT
    `S1`.`AnswerableID`                                    AS `AnswerableID`,
    `S1`.`AnswerableGroupID`                               AS `AnswerableGroupID`,
    `S1`.`QuestionID`                                      AS `QuestionID`,
    `S5`.`AnsweredHTML`                                    AS `AnsweredHTML`,
    `S6`.`StartedBy`                                       AS `AnsweredBy`,
    `S1`.`AllowedAttempts`                                 AS `AllowedAttempts`,
    (CASE WHEN isnull(`S6`.`StartedBy`)
      THEN 0
     ELSE `S5`.`Attempts` END)                             AS `Attempts`,
    `S1`.`PointsWorth`                                     AS `PointsWorth`,
    `S1`.`CorrectAnswer`                                   AS `CorrectAnswer`,
    `S5`.`ChosenAnswer`                                    AS `ChosenAnswer`,
    (`S1`.`CorrectAnswer` IS NOT NULL)                     AS `HasCorrectAnswer`,
    (CASE WHEN isnull(`S6`.`StartedBy`)
      THEN `S1`.`AllowedAttempts`
     ELSE (`S1`.`AllowedAttempts` - `S5`.`Attempts`) END)  AS `RemainingAttempts`,
    (CASE WHEN isnull(`S6`.`StartedBy`)
      THEN 1
     ELSE (`S1`.`AllowedAttempts` > `S5`.`Attempts`) END)  AS `Answerable`,
    (CASE WHEN isnull(`S6`.`StartedBy`)
      THEN 0
     ELSE (`S1`.`AllowedAttempts` >= `S5`.`Attempts`) END) AS `Locked`,
    (`S5`.`ChosenAnswer` IS NOT NULL)                      AS `HasAnswer`,
    (CASE WHEN (`S5`.`ChosenAnswer` = `S1`.`CorrectAnswer`)
      THEN 1
     ELSE 0 END)                                           AS `IsCorrect`
  FROM ((`hecflore_CELO`.`AnswerableQuestions` `S1` LEFT JOIN `hecflore_CELO`.`AnsweredQuestions` `S5`
      ON ((`S5`.`AnswerableID` = `S1`.`AnswerableID`))) LEFT JOIN `hecflore_CELO`.`AnsweringQuestionsGroup` `S6`
      ON ((`S6`.`AnsweringGroupID` = `S5`.`AnsweringGroupID`)));
CREATE VIEW `AnsweredQuestionsReport` AS
  SELECT
    `S1`.`AnswerableID`                                    AS `AnswerableID`,
    `S5_2`.`AnsweringGroupID`                              AS `AnsweringGroupID`,
    `S1`.`AnswerableGroupID`                               AS `AnswerableGroupID`,
    `S1`.`QuestionID`                                      AS `QuestionID`,
    `S5`.`AnsweredHTML`                                    AS `AnsweredHTML`,
    `S5_2`.`StartedBy`                                     AS `AnsweredBy`,
    `S1`.`AllowedAttempts`                                 AS `AllowedAttempts`,
    (CASE WHEN isnull(`S5_2`.`StartedBy`)
      THEN 0
     ELSE `S5`.`Attempts` END)                             AS `Attempts`,
    `S1`.`PointsWorth`                                     AS `PointsWorth`,
    `S1`.`CorrectAnswer`                                   AS `CorrectAnswer`,
    `S5`.`ChosenAnswer`                                    AS `ChosenAnswer`,
    (`S1`.`CorrectAnswer` IS NOT NULL)                     AS `HasCorrectAnswer`,
    (CASE WHEN isnull(`S5_2`.`StartedBy`)
      THEN `S1`.`AllowedAttempts`
     ELSE (`S1`.`AllowedAttempts` - `S5`.`Attempts`) END)  AS `RemainingAttempts`,
    (CASE WHEN isnull(`S5_2`.`StartedBy`)
      THEN 1
     ELSE (`S1`.`AllowedAttempts` > `S5`.`Attempts`) END)  AS `Answerable`,
    (CASE WHEN isnull(`S5_2`.`StartedBy`)
      THEN 0
     ELSE (`S1`.`AllowedAttempts` >= `S5`.`Attempts`) END) AS `Locked`,
    (`S5`.`ChosenAnswer` IS NOT NULL)                      AS `HasAnswer`,
    (CASE WHEN (`S5`.`ChosenAnswer` = `S1`.`CorrectAnswer`)
      THEN 1
     ELSE 0 END)                                           AS `IsCorrect`,
    `S4`.`CreatedOn`                                       AS `CreatedOn`,
    `S4`.`CreatedBy`                                       AS `CreatedBy`,
    `S3`.`QuestionType`                                    AS `QuestionType`,
    `S3`.`Question`                                        AS `Question`,
    `S3`.`ExpectedAnswer`                                  AS `ExpectedAnswer`,
    `S3`.`JSONParameters`                                  AS `JSONParameters`,
    `S2`.`UserID`                                          AS `UserID`,
    `S2`.`FirstName`                                       AS `FirstName`,
    `S2`.`LastName`                                        AS `LastName`,
    `S2`.`Email`                                           AS `Email`,
    `S2`.`PhoneNumber`                                     AS `PhoneNumber`,
    `S2`.`UserName`                                        AS `UserName`,
    `S2`.`Password`                                        AS `Password`,
    `S2`.`Role`                                            AS `Role`,
    `S2`.`UHID`                                            AS `UHID`,
    (CASE WHEN ((`S5`.`ChosenAnswer` IS NOT NULL) AND (`S5`.`ChosenAnswer` = `S1`.`CorrectAnswer`))
      THEN `S1`.`PointsWorth`
     ELSE 0 END)                                           AS `PointsEarned`
  FROM (((`hecflore_CELO`.`AnswerableQuestions` `S1` LEFT JOIN `hecflore_CELO`.`Questions` `S3`
      ON ((`S3`.`QuestionID` = `S1`.`QuestionID`))) LEFT JOIN `hecflore_CELO`.`AnswerableQuestionsGroups` `S4`
      ON ((`S4`.`AnswerableGroupID` = `S1`.`AnswerableGroupID`))) JOIN ((`hecflore_CELO`.`Users` `S2`
    JOIN `hecflore_CELO`.`AnsweringQuestionsGroup` `S5_2` ON ((`S2`.`UserID` = `S5_2`.`StartedBy`))) JOIN
    `hecflore_CELO`.`AnsweredQuestions` `S5` ON ((`S5`.`AnsweringGroupID` = `S5_2`.`AnsweringGroupID`))))
  WHERE (`S1`.`AnswerableID` = `S5`.`AnswerableID`)
  UNION ALL SELECT
              `S1`.`AnswerableID`                AS `AnswerableID`,
              `S13`.`AnsweringGroupID`           AS `AnsweringGroupID`,
              `S1`.`AnswerableGroupID`           AS `AnswerableGroupID`,
              `S1`.`QuestionID`                  AS `QuestionID`,
              NULL                               AS `AnsweredHTML`,
              NULL                               AS `AnsweredBy`,
              `S1`.`AllowedAttempts`             AS `AllowedAttempts`,
              0                                  AS `Attempts`,
              `S1`.`PointsWorth`                 AS `PointsWorth`,
              `S1`.`CorrectAnswer`               AS `CorrectAnswer`,
              NULL                               AS `ChosenAnswer`,
              (`S1`.`CorrectAnswer` IS NOT NULL) AS `HasCorrectAnswer`,
              `S1`.`AllowedAttempts`             AS `RemainingAttempts`,
              1                                  AS `Answerable`,
              0                                  AS `Locked`,
              0                                  AS `HasAnswer`,
              0                                  AS `IsCorrect`,
              `S4`.`CreatedOn`                   AS `CreatedOn`,
              `S4`.`CreatedBy`                   AS `CreatedBy`,
              `S3`.`QuestionType`                AS `QuestionType`,
              `S3`.`Question`                    AS `Question`,
              `S3`.`ExpectedAnswer`              AS `ExpectedAnswer`,
              `S3`.`JSONParameters`              AS `JSONParameters`,
              `S2`.`UserID`                      AS `UserID`,
              `S2`.`FirstName`                   AS `FirstName`,
              `S2`.`LastName`                    AS `LastName`,
              `S2`.`Email`                       AS `Email`,
              `S2`.`PhoneNumber`                 AS `PhoneNumber`,
              `S2`.`UserName`                    AS `UserName`,
              `S2`.`Password`                    AS `Password`,
              `S2`.`Role`                        AS `Role`,
              `S2`.`UHID`                        AS `UHID`,
              0                                  AS `PointsEarned`
            FROM ((`hecflore_CELO`.`Users` `S2`
              JOIN `hecflore_CELO`.`UsersAnswersTemp` `S5`) JOIN ((
                (`hecflore_CELO`.`AnswerableQuestions` `S1` LEFT JOIN `hecflore_CELO`.`Questions` `S3`
                    ON ((`S3`.`QuestionID` = `S1`.`QuestionID`))) LEFT JOIN
                `hecflore_CELO`.`AnswerableQuestionsGroups` `S4`
                  ON ((`S4`.`AnswerableGroupID` = `S1`.`AnswerableGroupID`))) JOIN
              `hecflore_CELO`.`AnsweringQuestionsGroup` `S13`
                ON ((`S13`.`AnswerableGroupID` = `S4`.`AnswerableGroupID`))))
            WHERE ((`S1`.`AnswerableID` = `S5`.`AnsweredBy`) AND (NOT (`S2`.`UserID` IN (SELECT DISTINCT `S13`.`StartOn`
                                                                                         FROM (
                                                                                             `hecflore_CELO`.`AnsweredQuestions` `S12`
                                                                                             JOIN
                                                                                             `hecflore_CELO`.`AnsweringQuestionsGroup` `S13`
                                                                                               ON ((
                                                                                               `S13`.`AnsweringGroupID`
                                                                                               =
                                                                                               `S12`.`AnsweringGroupID`)))
                                                                                         WHERE (`S12`.`AnswerableID` =
                                                                                                `S1`.`AnswerableID`)))));
CREATE VIEW `CourseContentBreadcrumbs` AS
  SELECT
    `S2`.`ContentID`      AS `ContentID`,
    `S1`.`ParentFolderID` AS `PreviousContentID`,
    `S1`.`ContentID`      AS `CurrentContentID`,
    `S2`.`ChildContentID` AS `ChildContentID`,
    `S1`.`SectionID`      AS `SectionID`,
    `S1`.`Name`           AS `Name`,
    `S1`.`URL`            AS `URL`,
    `S1`.`Description`    AS `Description`,
    `S1`.`ParentFolderID` AS `ParentFolderID`,
    `S1`.`RootContentID`  AS `RootContentID`,
    `S1`.`Depth`          AS `Depth`,
    `S1`.`Type`           AS `Type`,
    `S1`.`Properties`     AS `Properties`,
    `S1`.`Gradable`       AS `Gradable`,
    `S1`.`CreatedBy`      AS `CreatedBy`,
    `S1`.`RolesVisible`   AS `RolesVisible`
  FROM (`hecflore_CELO`.`CourseContentChildren` `S2`
    JOIN `hecflore_CELO`.`CourseContent` `S1` ON ((`S1`.`ContentID` = `S2`.`ContentID`)));
CREATE VIEW `CourseContentBreadcrumbsForward` AS
  SELECT
    `S2`.`ContentID`      AS `ContentID`,
    `S1`.`ParentFolderID` AS `PreviousContentID`,
    `S1`.`ContentID`      AS `CurrentContentID`,
    `S2`.`ChildContentID` AS `ChildContentID`,
    `S1`.`SectionID`      AS `SectionID`,
    `S1`.`Name`           AS `Name`,
    `S1`.`URL`            AS `URL`,
    `S1`.`Description`    AS `Description`,
    `S1`.`ParentFolderID` AS `ParentFolderID`,
    `S1`.`RootContentID`  AS `RootContentID`,
    `S1`.`Depth`          AS `Depth`,
    `S1`.`Type`           AS `Type`,
    `S1`.`Properties`     AS `Properties`,
    `S1`.`Gradable`       AS `Gradable`,
    `S1`.`CreatedBy`      AS `CreatedBy`,
    `S1`.`RolesVisible`   AS `RolesVisible`
  FROM (`hecflore_CELO`.`CourseContentChildren` `S2`
    JOIN `hecflore_CELO`.`CourseContent` `S1` ON ((`S1`.`ContentID` = `S2`.`ChildContentID`)));
CREATE VIEW `CourseContentReport` AS
  SELECT
    `S3`.`CourseUniqueID`      AS `CourseUniqueID`,
    `S1`.`ContentID`           AS `CourseContent_ContentID`,
    `S1`.`SectionID`           AS `CourseContent_SectionID`,
    `S1`.`Name`                AS `CourseContent_Name`,
    `S1`.`URL`                 AS `CourseContent_URL`,
    `S1`.`Description`         AS `CourseContent_Description`,
    `S1`.`ParentFolderID`      AS `CourseContent_ParentFolderID`,
    `S1`.`Type`                AS `CourseContent_Type`,
    `S1`.`Properties`          AS `CourseContent_Properties`,
    `S1`.`Gradable`            AS `CourseContent_Gradable`,
    `S1`.`CreatedBy`           AS `CourseContent_CreatedBy`,
    `S1`.`RolesVisible`        AS `CourseContent_RolesVisible`,
    `S2`.`SectionID`           AS `Sections_SectionID`,
    `S2`.`SectionNumber`       AS `Sections_SectionNumber`,
    `S2`.`StartDate`           AS `Sections_StartDate`,
    `S2`.`EndDate`             AS `Sections_EndDate`,
    `S2`.`Location`            AS `Sections_Location`,
    `S2`.`TextBookInformation` AS `Sections_TextBookInformation`,
    `S2`.`CreatedBy`           AS `Sections_CreatedBy`,
    `S2`.`MainCourseContentID` AS `Sections_MainCourseContentID`,
    `S4`.`UserID`              AS `Section_CreatedBy_UserID`,
    `S4`.`FirstName`           AS `Section_CreatedBy_FirstName`,
    `S4`.`LastName`            AS `Section_CreatedBy_LastName`,
    `S4`.`Email`               AS `Section_CreatedBy_Email`,
    `S4`.`PhoneNumber`         AS `Section_CreatedBy_PhoneNumber`,
    `S4`.`UserName`            AS `Section_CreatedBy_UserName`,
    `S4`.`Password`            AS `Section_CreatedBy_Password`,
    `S4`.`Role`                AS `Section_CreatedBy_Role`,
    `S4`.`UHID`                AS `Section_CreatedBy_UHID`,
    `S3`.`CourseName`          AS `Course_CourseName`,
    `S3`.`CourseCategory`      AS `Course_CourseCategory`,
    `S3`.`Setup`               AS `Course_Setup`,
    `S3`.`CourseID`            AS `Course_CourseID`,
    `S3`.`Description`         AS `Course_Description`,
    `S3`.`CourseStatus`        AS `Course_CourseStatus`,
    `S3`.`CreatedBy`           AS `Course_CreatedBy`
  FROM (((`hecflore_CELO`.`CourseContent` `S1` LEFT JOIN `hecflore_CELO`.`Sections` `S2`
      ON ((`S1`.`SectionID` = `S2`.`SectionID`))) LEFT JOIN `hecflore_CELO`.`Users` `S4`
      ON ((`S4`.`UserID` = `S2`.`CreatedBy`))) LEFT JOIN `hecflore_CELO`.`Courses` `S3`
      ON ((`S3`.`CourseUniqueID` = `S2`.`CourseUniqueID`)));
CREATE VIEW `CourseSectionsReport` AS
  SELECT
    `S1`.`CourseUniqueID`       AS `CourseUniqueID`,
    `S1`.`CourseName`           AS `CourseName`,
    `S1`.`CourseCategory`       AS `CourseCategory`,
    `S1`.`Setup`                AS `Setup`,
    `S1`.`CourseID`             AS `CourseID`,
    `S1`.`Description`          AS `Description`,
    `S1`.`CourseStatus`         AS `CourseStatus`,
    `S2`.`SectionID`            AS `SectionID`,
    `S2`.`SectionNumber`        AS `SectionNumber`,
    `S2`.`StartDate`            AS `StartDate`,
    `S2`.`EndDate`              AS `EndDate`,
    `S2`.`Location`             AS `Location`,
    `S2`.`TextBookInformation`  AS `TextBookInformation`,
    `S2`.`MainCourseContentID`  AS `MainCourseContentID`,
    `S2`.`CreatedBy`            AS `CreatedBy`,
    `S3`.`AssignedBy`           AS `AssignedBy`,
    (CASE WHEN isnull(`S4`.`UserID`)
      THEN `S2`.`CreatedBy`
     ELSE `S4`.`UserID` END)    AS `UserID`,
    `S4`.`FirstName`            AS `FirstName`,
    `S4`.`LastName`             AS `LastName`,
    `S4`.`Email`                AS `Email`,
    `S4`.`PhoneNumber`          AS `PhoneNumber`,
    `S4`.`UserName`             AS `UserName`,
    `S4`.`Password`             AS `Password`,
    `S4`.`Role`                 AS `Role`,
    `S3`.`UHID`                 AS `UHID`,
    (`S4`.`UserID` IS NOT NULL) AS `isActive`
  FROM (((`hecflore_CELO`.`Courses` `S1` LEFT JOIN `hecflore_CELO`.`Sections` `S2`
      ON ((`S1`.`CourseUniqueID` = `S2`.`CourseUniqueID`))) LEFT JOIN `hecflore_CELO`.`SectionUsers` `S3`
      ON ((`S2`.`SectionID` = `S3`.`SectionID`))) LEFT JOIN `hecflore_CELO`.`Users` `S4`
      ON (((isnull(`S3`.`UserID`) AND (`S3`.`UHID` = `S4`.`UHID`)) OR
           ((`S3`.`UserID` IS NOT NULL) AND (`S3`.`UserID` = `S4`.`UserID`)))));
CREATE VIEW `GradeProgress_CourseContentTree` AS
  SELECT
    `S1`.`ContentID`                                                          AS `ContentID`,
    `S1`.`ChildContentID`                                                     AS `ChildContentID`,
    `S4`.`Name`                                                               AS `Name`,
    `S4`.`Type`                                                               AS `Type`,
    `S4`.`Depth`                                                              AS `Depth`,
    `S7`.`UserID`                                                             AS `UserID`,
    (CASE WHEN isnull(`S3`.`PointsEarned`)
      THEN 0
     ELSE ((sum(`S3`.`PointsEarned`) / sum(`S3`.`PointsWorth`)) * 100.0) END) AS `Grade`
  FROM (((`hecflore_CELO`.`CourseContentBreadcrumbs` `S1` LEFT JOIN `hecflore_CELO`.`CourseContent` `S4`
      ON ((`S4`.`ContentID` = `S1`.`ChildContentID`))) LEFT JOIN `hecflore_CELO`.`AnswerableQuestionsGroups` `S2`
      ON ((`S2`.`CourseContentID` = `S1`.`ChildContentID`))) LEFT JOIN `hecflore_CELO`.`AnsweredQuestionsReport` `S3`
      ON ((`S3`.`AnswerableGroupID` = `S2`.`AnswerableGroupID`))) JOIN `hecflore_CELO`.`Users` `S7`
  WHERE (`S7`.`UserID` = `S3`.`UserID`)
  GROUP BY `S1`.`ContentID`, `S1`.`ChildContentID`, `S1`.`Name`, `S1`.`Type`, `S1`.`Depth`, `S7`.`UserID`;
CREATE VIEW `QuestionsReport` AS
  SELECT
    `S1`.`QuestionID`      AS `QuestionID`,
    `S1`.`QuestionType`    AS `QuestionType`,
    `S1`.`Question`        AS `Question`,
    `S1`.`ExpectedAnswer`  AS `ExpectedAnswer`,
    `S1`.`CreatedBy`       AS `CreatedBy`,
    `S1`.`JSONParameters`  AS `JSONParameters`,
    `S1`.`QuestionsPoolID` AS `QuestionsPoolID`,
    `S3`.`FirstName`       AS `FirstName`,
    `S3`.`LastName`        AS `LastName`,
    `S3`.`Email`           AS `Email`,
    `S3`.`PhoneNumber`     AS `PhoneNumber`
  FROM (`hecflore_CELO`.`Questions` `S1` LEFT JOIN `hecflore_CELO`.`Users` `S3` ON ((`S3`.`UserID` = `S1`.`CreatedBy`)));
CREATE VIEW `QuestionTypesReport` AS
  SELECT
    `S1`.`QuestionTypeID` AS `QuestionTypeID`,
    `S1`.`SrcDirectory`   AS `SrcDirectory`,
    `S1`.`Name`           AS `Name`,
    `S1`.`CreatedBy`      AS `CreatedBy`,
    `S3`.`UserID`         AS `UserID`,
    `S3`.`FirstName`      AS `FirstName`,
    `S3`.`LastName`       AS `LastName`,
    `S3`.`Email`          AS `Email`,
    `S3`.`PhoneNumber`    AS `PhoneNumber`,
    `S3`.`UserName`       AS `UserName`,
    `S3`.`Password`       AS `Password`,
    `S3`.`Role`           AS `Role`,
    `S3`.`UHID`           AS `UHID`
  FROM (`hecflore_CELO`.`QuestionTypes` `S1` LEFT JOIN `hecflore_CELO`.`Users` `S3`
      ON ((`S3`.`UserID` = `S1`.`CreatedBy`)));
CREATE VIEW `RunningAssessmentsReport` AS
  SELECT
    `S1`.`AnsweredID`                                                                                              AS `AnsweredID`,
    `S1`.`AssessmentID`                                                                                            AS `AssessmentID`,
    `S1`.`StartTime`                                                                                               AS `StartTime`,
    `S1`.`EndTime`                                                                                                 AS `EndTime`,
    `S1`.`TotalPoints`                                                                                             AS `TotalPoints`,
    sum(
        `S4`.`PointsEarned`)                                                                                       AS `EarnedPoints`,
    count(
        `S6`.`AnswerableID`)                                                                                       AS `Answered`,
    count(
        `S4`.`AnswerableID`)                                                                                       AS `TotalQuestions`,
    ((sum(`S4`.`PointsEarned`) / `S1`.`TotalPoints`) *
     100.0)                                                                                                        AS `Grade`,
    (((sum(`S4`.`PointsEarned`) / `S1`.`TotalPoints`) / (sum((CASE WHEN (`S4`.`Attempts` = 0)
      THEN 1
                                                              ELSE 0 END)) / count(`S4`.`AnswerableID`))) *
     100.0)                                                                                                        AS `RelativeGrade`,
    ((sum((CASE WHEN (`S4`.`Attempts` = 0)
      THEN 1
           ELSE 0 END)) / count(`S6`.`AnswerableID`)) *
     100.0)                                                                                                        AS `Finished`,
    `S1`.`AnsweringBy`                                                                                             AS `AnsweringBy`,
    `S1`.`GradedBy`                                                                                                AS `GradedBy`,
    `S1`.`AnsweringGroupID`                                                                                        AS `AnsweringGroupID`,
    `S2`.`Name`                                                                                                    AS `Name`,
    `S2`.`URL`                                                                                                     AS `URL`,
    `S2`.`Description`                                                                                             AS `Description`,
    `S2`.`Type`                                                                                                    AS `Type`,
    `S2`.`Properties`                                                                                              AS `Properties`,
    `S2`.`AssociatedCourseContentID`                                                                               AS `AssociatedCourseContentID`,
    `S2`.`Timelimit`                                                                                               AS `Timelimit`
  FROM (((((`hecflore_CELO`.`RunningAssessments` `S1`
    JOIN `hecflore_CELO`.`Assessments` `S2` ON ((`S2`.`AssessmentID` = `S1`.`AssessmentID`))) JOIN
    `hecflore_CELO`.`AnsweringQuestionsGroup` `S3` ON ((`S3`.`AnsweringGroupID` = `S1`.`AnsweringGroupID`))) LEFT JOIN
    `hecflore_CELO`.`AnsweredQuestionsReport` `S4` ON (((`S4`.`AnswerableGroupID` = `S3`.`AnswerableGroupID`) AND
                                                        (`S1`.`AnsweringBy` = `S4`.`AnsweredBy`)))) LEFT JOIN
    `hecflore_CELO`.`AnswerableQuestions` `S5` ON (((`S5`.`AnswerableGroupID` = `S3`.`AnswerableGroupID`) AND
                                                    (`S4`.`AnswerableID` = `S5`.`AnswerableID`)))) LEFT JOIN
    `hecflore_CELO`.`AnsweredQuestions` `S6` ON ((`S6`.`AnsweringGroupID` = `S1`.`AnsweringGroupID`)))
  GROUP BY `S1`.`AnsweredID`, `S1`.`AssessmentID`, `S1`.`StartTime`, `S1`.`EndTime`, `S1`.`TotalPoints`,
    `S1`.`EarnedPoints`, `S1`.`AnsweringBy`, `S1`.`GradedBy`, `S1`.`AnsweringGroupID`, `S2`.`Name`, `S2`.`URL`,
    `S2`.`Description`, `S2`.`Type`, `S2`.`Properties`, `S2`.`AssociatedCourseContentID`, `S2`.`Timelimit`;
CREATE VIEW `UsersAnswersTemp` AS
  SELECT
    `S8`.`AnswerableID` AS `AnswerableID`,
    `S9`.`AnsweredHTML` AS `AnsweredHTML`,
    `S3`.`StartedBy`    AS `AnsweredBy`,
    `S9`.`Attempts`     AS `Attempts`,
    `S9`.`ChosenAnswer` AS `ChosenAnswer`,
    `S10`.`UserID`      AS `UserID`,
    `S10`.`FirstName`   AS `FirstName`,
    `S10`.`LastName`    AS `LastName`,
    `S10`.`Email`       AS `Email`,
    `S10`.`PhoneNumber` AS `PhoneNumber`,
    `S10`.`UserName`    AS `UserName`,
    `S10`.`Password`    AS `Password`,
    `S10`.`Role`        AS `Role`,
    `S10`.`UHID`        AS `UHID`
  FROM (((`hecflore_CELO`.`AnswerableQuestions` `S8` LEFT JOIN `hecflore_CELO`.`AnsweredQuestions` `S9`
      ON ((`S9`.`AnswerableID` = `S8`.`AnswerableID`))) JOIN `hecflore_CELO`.`AnsweringQuestionsGroup` `S3`
      ON (((`S3`.`AnswerableGroupID` = `S8`.`AnswerableGroupID`) AND
           (`S3`.`AnsweringGroupID` = `S9`.`AnsweringGroupID`)))) LEFT JOIN `hecflore_CELO`.`Users` `S10`
      ON ((`S3`.`StartedBy` = `S10`.`UserID`)));






