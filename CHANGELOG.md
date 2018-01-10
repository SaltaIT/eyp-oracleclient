# CHANGELOG

## 0.2.29

* added support for tools on **oracleclient::instantclient**

## 0.2.28

* bugfix identation

## 0.2.26

* added more options to **oracleclient::connectstring**:
  - community
  - sid
  - global_name
* dbname (**SERVICE_NAME**) is no longer mandatory in **oracleclient::connectstring**

## 0.2.25

* bugfix: honor **oracleclient::instantclient::ver**

## 0.2.24

* added puppet managed file header to tnsnames
* increased description banner size per connectstring for improved readability

## 0.2.23

* renamed oracleclient::connectstring **comment** to **description**

## 0.2.22

* added optional comment on tnsnames
* added puppet managed file on sqlnet.ora

## 0.2.20

* bugfix instantclient dependencies

## 0.2.19

* bugfix which wget duplicate declaration

## 0.2.18

* added oracleclient::instantclient

## 0.2.17

* added ${srcdir}/client/.eyp-runInstalled.sh to remount /tmp with exec

## 0.2.16

* added onlyif for  exec "runinstaller client ${version} rootsh" (**${oraclehome}/root.sh**)

## 0.2.15

* added execution of /u01/app/oraInventory/orainstRoot.sh

## 0.2.14

* updated dependencies
* include ::ldconfig class

## 0.2.12

* added instance_name

## 0.2.11

* allow URLs for **oracleclient::package**

## 0.2.10

* fixed dependency typo

## 0.2.9

* added ldconfig configuration files using **eyp-ldconfig** (mandatory dependency)

## 0.2.8

* bugfix **version_with_underscore**

## 0.2.7

* added option **localfile** to be able to use a already existing file on the system as a source for **oracleclient package**

## 0.2.6

* added **version_with_underscore** to generate responsefile for 11c

## 0.2.5

* lint + clenaup

## 0.2.4

* Corrected tnsnames.ora generation from template

## 0.2.3

* Modified runInstaller completion check for oracle11

## 0.2.2

* Added selector for runInstaller command

## 0.2.1

* added support for oracle 11c

## 0.1.9

* support for oracle 12c
