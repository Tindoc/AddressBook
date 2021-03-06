# AddressBook 通讯录
> 本项目是根据周宏斌、温一军主编的《C#数据库应用程序开发技术与案例教程》实现的程序
>
> 官方教辅资源 [在此](http://www.hzcourse.com/web/teachRes/detail/3328/209) ，需要登录（不想注册）
>
> CSDN 有付费资源（没有积分）

## 项目说明

### 主要功能

- 用户登录：只支持在数据库中初始化用户
- 联系人分组管理：增删改查联系人分组信息
- 联系人管理：增删改查联系人信息
- 用户密码修改：修改自己的密码
- 数据库备份与恢复：如果需要使用 SQL Server 数据库的备份和恢复需要部署数据库环境在本地
- 系统帮助：显示产品名称、版本号、版权、公司名称等

### 文件结构

> 以 AddressBookMVC 项目为例

Model 类库项目：针对使用的 3 张表建立各个类文件，里面设置各表字段的属性

BLL 类库项目：实现业务功能的函数，但并不真正实现数据库访问等，通过调用 IDAL 的 xxxDAL 类来实现（大致是按功能来划分类文件的，有 4 个）

xxxDAL 类库项目：实现真正的数据库访问，而且都实现了 IDAL 类库项目的接口（与 BLL 对应）

IDAL 类库项目：接口的定义（与 xxxDAL 对应）

DALFactory 类库项目：决定调用哪个数据库的工厂模式（与 BLL 对应）

Common 类库项目：通用函数的集合

WinForm 窗体项目：表示层

### 其他

数据库支持 SQL Server 和 Access ，只需在 WinFrom/App.config 文件中配置按提示配置即可

## Repo 说明

[AddressBookSetup](./AddressBookSetup) 是任务9实现的安装程序项目，编译后可以移动到用户电脑安装使用

[AddressBook](./AddressBook) 是实现任务12之后的状态，即未使用MVC架构的可使用程序（只支持 SQL Server 数据库）

[AddressBookMVC](./AddressBookMVC) 是任务13实现的对 AddressBook 项目进行 MVC 架构的重构项目

[SqlServerSetting](./SqlServerSetting) 是SQL Server 数据库环境的恢复脚本，脚本中包含了登录的用户名和密码(同为 admin)和任务11的存储过程，**但缺少外键(可能在更新通讯录分组时无法更新通讯录里的 GroupId 问题，请自行添加外键，Contact.GroupId = ContactGroup.Id)**。可根据 [SqlServerSetting/readme.md](./SqlServerSetting/readme.md) 提示配置数据库环境。

[assets](./assets) 为存放本说明文件使用的图片的文件夹

另：

可以使用 GitHub 上 [本项目](https://github.com/Tindoc/AddressBook) 的 Tags 来下载或克隆到某一特定时期，Tags 如下

- “基础篇”：完成基础篇之后的状态，使用的是格式化字符串书写 sql 语句
- “BeforeDbHelper”：实现任务11后的状态，即在 “Tags:基础篇” 基础上使用参数化 sql 语句
- “进阶篇”：完成进阶篇之后的状态，即在 “Tags:BeforeDbHelper” 基础上使用数据库操作类操作数据库
- “MVC”：实现任务15后的状态，即在 “Tags:进阶篇” 上使用 MVC 重构以及使用抽象工厂访问数据库的项目

> 推荐使用后三个



# 任务记录

> 记录按照书中做任务过程中重要或者疑惑的地方

### Task 2

ToolStrip 工具栏上添加的是 button ，根据控件名称 tsbtnxxxx 得知

可以使用 public 类的 static 成员来保存程序整个运行期间不变的变量，类 DBHelper 就是如此

### Task 5

ComboBox 的 DropDownStyle 属性设置为 DropDownList 之后只能在组合框中选取

### Task 7

**注意：**需要 using System.IO 才可以使用 File 类

**注意：**这个备份和恢复只能在客户端和数据库在同一台主机上才可以实现，暂不支持远程备份

### Task 11

Stored Procedure 存储过程优点：

- 预编译：存储过程预先编译好放在数据库内，减少编译语句所花的时间
- 缓存：编译好的会进入缓存，第二次执行的速度明显提高
- 减少网络传输：

### Task12

对数据库的操作分为四类：

- 对数据库进行非连接式查询操作，返回多条记录。可以通过 SqlDataAdapter 对象的 Fill 方法来完成
- 对数据库进行连接式查询操作，返回多条查询记录。可以通过 SqlCommand 对象的 ExecuteReader 方法来完成
- 从数据库中检索单个值。可以通过 SqlCommand 对象的 ExecuteScalar 来完成
- 对数据库执行增、删、改操作。可以通过 SqlCommand 对象的 ExecuteNonQuery 来完成

### Task 13

![三层架构演变](assets/三层架构演变.png)

> 其中
>
> 表示层：只提供软件系统与用户交互的接口
>
> 业务逻辑层：负责数据处理的传递
>
> 数据访问层：数据的存取工作
>
> 业务实体：封装实体类数据结构，一般用于映射数据库的数据表或视图（多少个表多少个实体），用以描述业务中的对象，在各层中传递
>
> 通用类库：包含通用的辅助工具类

根据三层的依赖关系添加引用

**注意：**App.config 文件还是在窗体项目中建立，而不是在 SQLDAL 项目中建立

### Task 14

Access 不支持存储过程，所以书在 AccessDAL 类中函数不传 CommandType 参数，当其他提供 OleDb 支持的数据库可能能使用，所以保留

Access 的数据库备份就是 .mdb 文件的移动

**注意：**由于没有修改 表示层 代码，所以在 数据库备份和恢复 的窗体中设置的 OpenFileDialog 和 SaveFileDIalog 的筛选字符串不是很符合，导致备份的文件后缀为 .bak 而不是 .mdb

### Task 15

#### C# 使用反射动态创建类型的实例

1. 基础

    一个解决方案中多个项目，其中类库项目会生成 .dll 文件，窗体项目会生成 .exe 文件，这两个文件都是 “程序集”。

    如果窗体项目 A 需要引用类库项目 B，生成时会自动将 B 类库生成的 B.dll 文件复制到 A 项目的 bin/debug/ 文件夹下，如果B类库项目还依赖于类库项目 C ，则会自动将 C.dll 复制到 A 项目的 bin/debug/ 文件夹下

2. 使用

    ```c#
    using System.Reflection;

    Assembly.Load(“程序集名称”).CreateInstance("命名空间.类名称");
    ```

3. 解释

    使用反射动态创建类型的实例即后期绑定，属于动态编程，[官方介绍](https://docs.microsoft.com/zh-cn/dotnet/framework/reflection-and-codedom/)

**注意：**如果出现 “依赖项” 什么的出错，请在 WinForm 项目中添加 AccessDAL 和 SQLDAL 的引用，以在项目 bin/debug/ 文件夹中生成 AccessDAL.dll 和 SQLDAL.dll 动态链接库

# 待优化

- 使用 SqlDbHelper 类时创建参数麻烦，而且针对特定数据库

# 书籍勘误

- P46 第四行：*（1）定义FormContactList窗体的私有字段。* 应为 *（1）定义FormContact**Detail**窗体的私有字段。*

