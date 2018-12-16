# Blog

## 数据库表结构

### 管理员账户表(admins)

|字段名|类型|描述|
|:-------------:|:----:|:----:|
|id             |int   |管理员ID|
|username       |string|用户名|
|password_digest|string|密码|

**为username设置索引。**

### 用户表(users)

|字段名|类型|描述|
|:-------------:|:----:|:----:|
|id             |int   |用户ID|
|username       |string|用户名|
|password_digest|string|密码|
|email          |string|邮箱|

**为username设置索引。**

### 文章表(posts)

|字段名|类型|描述|
|:---------:|:------:|:----:|
|id         |int     |文章ID|
|user_id    |int     |作者ID|
|title      |string  |文章标题|
|content    |text    |文章内容|
|category   |string  |文章分类|
|audit      |int     |文章审核状态|
|created_at |date    |文章创建日期|
|updated_at |date    |文章更新日期|

**为category、created_at、audit设置索引。文章表中的user_id，用来关联作者的ID。**

### 留言表(comments)

|字段名|类型|描述|
|:---------:|:------:|:----:|
|id         |int     |留言ID|
|user_id    |int     |留言者ID|
|post_id    |int     |文章ID|
|content    |text    |留言内容|
|audit      |int     |留言审核状态|
|created_at |date    |留言创建日期|

**为audit设置索引。留言表中的user_id用来关联留言者的ID；post_id用来关联留言对应文章的ID。**

### 反馈表(feedbacks)

|字段名|类型|描述|
|:---------:|:-----:|:----:|
|id         |int    |反馈ID|
|user_id    |int    |反馈者ID|
|content    |text   |反馈内容|
|created_at |date   |反馈创建日期|

**反馈表中的user_id，用来关联反馈者的ID。**

## Model

### Admin

```
class Admin < ApplicationRecord
  validates :username, presence: { message: 'can\'t be blank' }
  validates :username, uniqueness: { message: 'already exists' }
  has_secure_password
  validates :password, length: { minimum: 6, message: 'length should be longer than 6 digits' }
  validates :password_confirmation, presence: { message: 'can\'t be blank' }
end
```

用validates和has_secure_password对Admin进行多种限制：

1. Admin的username必须存在且不能重复。
2. Admin的password必须存在且长度必须多于6位。
3. has_secure_password使Admin的密码在存入数据库时进行加密，保证存入数据库的密码并非明文。同时有password_confirmation对密码进行二次确认，password_confirmation必须存在。

### User

```
class User < ApplicationRecord
  has_many :posts
  has_many :comments
  has_many :feedbacks
  validates :username, presence: { message: 'can\'t be blank' }
  validates :username, uniqueness: { message: 'already exists' }
  has_secure_password
  validates :password, length: { minimum: 6, message: 'length should be longer than 6 digits' }
  validates :password_confirmation, presence: { message: 'can\'t be blank' }
  validates :email, presence: { message: 'can\'t be blank' }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: 'address is incorrect' }
end
```

与Admin相比User则多出了以下关联与限制：

1. User与posts、comments、feedbacks存在关联关系，表示一个user拥有多个post、comment和feedback。
2. User还需要email的信息，对email作出的限制为email必须存在且满足正则表达式表示的邮箱格式，例如：xxxx@xxxx.xxxx。

### Post

```
class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :user
  validates :title, presence: true, length: { minimum: 5 }
  validates :content, presence: true, length: { minimum: 10 }
  validates :category, presence: true
end
```

Post中的关联与限制如下：

1. Post与user、comments存在关联关系，表示一个post属于一个user，同时拥有多个comment，且post与comments之间存在依赖，当post删除时，该post所拥有的所有comments也将被删除。
2. Post的title必须存在且长度大于五个字符。
3. Post的content必须存在且长度大于十个字符。
4. Post的category必须存在。

### Comment

```
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
end
```

Comment中只存在关联关系：

1. Comment与user和post存在关联关系，表示一个comment属于一个user同时属于一个post。

### Feedback

```
class Feedback < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { minimum: 10 }
end
```

Feedback中的关联与限制如下：

1. Feedback与user存在关联关系，表示一个feedback属于一个user。
2. Feedback的content必须存在且长度大于10个字符。

## View

**视图部分统一使用了Bootstrap框架**

需要注意的有以下几点：

- 在`app/assets/stylesheets/application.scss`中设定了整个应用所用到的CSS：

```
.bg1 {
  background: url('background1.jpg') no-repeat center center fixed;
  -webkit-background-size: cover;
  -moz-background-size: cover;
  background-size: cover;
  -o-background-size: cover;
}
```

设定网页的背景图片，同时使背景固定不随滚动条的滚动而移动。

```
table {
  table-layout: fixed;
}
td{
  word-break: break-all;
  word-wrap:break-word;
}
```

设定了网页中的所有表格的CSS，使表格有固定的长度，同时会对表格中的内容自动换行，不会导致页面的拉伸。

```
pre{
  white-space: pre-wrap;
  white-space: -moz-pre-wrap;
  white-space: -o-pre-wrap;
  word-wrap: break-word;
  background-color: transparent;
  border-color: transparent;
}
```

网页中有一部分的内容是通过\<pre\>标签进行显示的，这个CSS使得\<pre\>标签内的内容空白字符能够正常显示，比如换行符与空格。

- 网页中显示时间的Ruby代码大致为`<%= post.created_at.localtime.to_s(:db) %>`形式，通过这个形式能够正常显示我们所在时区的时间。

- 部分页面中存在这样的代码`<% session[:position] = 'index' %>`，这段代码用session来记录当前用户所在的页面，以便在之后的操作进行完毕后要返回页面时能正确返回当前的页面。

## Controller

所有控制器中都存在类似的这段代码`redirect_to new_sessions_admin_path and return if session[:admin_id].nil?`，用于判断用户或管理员当前是否登陆，并根据登陆状态进行对应的跳转。

### Admins

Admins控制器中需要注意的代码如下：

```
  def create
    redirect_to admins_path and return unless session[:admin_id].nil?
    temp_admin_code = params[:admin_code]
    @admin = Admin.new
    @admin.username = params[:username]
    @admin.password = params[:password]
    @admin.password_confirmation = params[:password_confirmation]
    if temp_admin_code == 'uAiqw'
      if @admin.save
        flash[:notice] = '注册成功,请登录'
        redirect_to new_sessions_admin_path
      else
        flash[:notice] = '注册失败，出现以下错误！'
        render 'new'
      end
    else
      flash[:notice] = '注册失败，管理员注册码错误！'
      render 'new'
    end
  end
```

创建管理员账户时要求检查输入的管理员注册码是否正确，才能进行下一步的管理员注册步骤。

### Users

Users控制器中需要注意的代码如下：

```
  def update
    redirect_to new_session_path and return if session[:user_id].nil?
    @user = User.find(params[:id])
    temp_user = @user.authenticate(params.require(:user).permit(:old_password)[:old_password])
    if temp_user
      if @user.update(user_params)
        flash[:success] = '用户信息修改成功！'
      else
        flash[:failed] = '用户信息修改失败，存在以下错误！'
      end
    else
      flash[:failed] = '旧密码错误,无法进行修改！'
    end
    render 'edit'
  end
```

在对User的相应信息进行修改时（比如修改密码与联系邮箱，用户名不可修改！），要先验证旧密码的正确性，旧密码正确才能进行下一步的修改。

### Sessions/Sessions_admin

这两个控制器用于执行用户或管理员的登陆与退出登陆操作。其中：

```angular
  def create
    redirect_to posts_path and return unless session[:user_id].nil?
    @temp_user = User.find_by_username(params[:username])
    if @temp_user
      @user = @temp_user.authenticate(params[:password])
      if @user
        session[:user_id] = @user.id
        redirect_to posts_path
      else
        flash[:notice] = '用户名或者密码不正确'
        render 'new'
      end
    else
      flash[:notice] = '用户名或者密码不正确'
      render 'new'
    end
  end
```

通过`has_secure_password`提供的用于验证密码的`authenticate(params[:password])`方法对用户或管理员输入的密码进行验证，在用户或管理员的用户名与密码正确时，将`session[:user_id]/session[:admin_id]`设置上对应的值，并跳转到用户与管理员的默认界面。

```
  def destroy
    redirect_to new_session_path and return if session[:user_id].nil?
    session[:user_id] = nil
    flash[:notice] = '退出登陆成功'
    redirect_to new_session_path
  end
```

退出时则将session中存储的登陆状态值清空，并返回登陆界面。

### Posts

Posts控制器中需要注意的代码如下：

```
  def audit_success
    redirect_to new_sessions_admin_path and return if session[:admin_id].nil?
    @post = Post.find(params[:id])
    @post.update(audit: 1)
    flash[:audit] = 'post'
    redirect_to admins_path
  end

  def audit_failed
    redirect_to new_sessions_admin_path and return if session[:admin_id].nil?
    @post = Post.find(params[:id])
    @post.update(audit: 2)
    flash[:audit] = 'post'
    redirect_to admins_path
  end
```

这两个动作用来对Post的审核状态进行改变，audit默认值为0，审核通过将audit值设为1，不通过则设为2，用于检索审核通过的文章以及管理员界面的不同审核状态文章的排序。

```
  def destroy
    redirect_to new_session_path and return if session[:user_id].nil? && session[:admin_id].nil?
    flash[:link] = flash[:position]
    @post = Post.find(params[:id])
    if @post.user_id == session[:user_id] || session[:admin_id]
      flash[:notice] = '删除成功'
      @post.destroy
    else
      flash[:notice] = '删除失败（您没有权限）！'
    end
    if session[:position] == 'profile'
      redirect_to user_path(session[:user_id])
    else
      redirect_to admin_path(session[:admin_id])
    end
  end
```

Post删除时则会对当前session中存储的值进行判断，只有管理员或者Post的作者才有权限删除Post。

### Comments

Comments控制器中动作的功能大致与Posts中的相同，需要注意的只有以下代码：

```
  def destroy
    redirect_to new_session_path and return if session[:user_id].nil? && session[:admin_id].nil?
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    if @comment.user_id == session[:user_id] || @comment.post.user_id == session[:user_id] || session[:admin_id]
      flash[:notice] = '删除成功'
      @comment.destroy
    else
      flash[:notice] = '删除失败（您没有权限）！'
    end
    if session[:position_comment] == 'admin_comment'
      redirect_to '/admins/show_comments'
    elsif session[:position_comment] == 'user_comment'
      redirect_to '/users/show_comments'
    elsif session[:position_comment] == 'post_admin_comment'
      redirect_to post_show_admin_path(@post)
    else
      redirect_to post_path(@post)
    end
  end
```

对于Comment而言，有删除权限的除了管理员和Comment的作者外，Comment所在Post的作者也拥有删除的权限。

### Feedbacks

Feedbacks控制器中只存在两个基本的动作：new和create。创建Feedback时会对Feedback的各个值进行数据验证。

## Other

### Kaminari

Blog中的分页功能通过Kaminari插件实现，具体的使用如下：

1. 在Model对象上使用`.page()`和`.per()`这两个方法,即可对要显示的数据进行分页，`.per()`方法决定每页显示的数据个数，`.page()`方法决定显示的页数。具体使用如`@posts = Post.where(audit: 1).order(created_at: :desc).page(params[:page]).per(5)`。
2. 在View页面中使用`<%= paginate @posts %>`类似的代码用于显示换页按钮。
3. 换页按钮的样式与显示文字分别在`app/views/kaminari`和`config/locales/en.yml`下进行设定。
