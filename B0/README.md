# StudentClass
使用`require 'yaml'`来加载yaml相关的拓展。  
构造了一个Student类，有着四个属性：id、name、gender、age。通过`attr_accessor :id, :name, :gender, :age`同时为四个属性创建读取和写入方法。Student类中的两个方法，to_s方法用于输出student实例的信息,hashValue方法用于将student实例的信息构造成hash形式。  
  
`createStuInfo`方法通过each迭代生成随机的100个学生信息，其中：  
```
def randomName(len)
  rand_indexes = (0...len).collect{|i| rand(26)}
  [*('a'..'z')].values_at(*rand_indexes).join
end
```
这段代码通过输入一个数，来生成对应长度的由26个小写字母随机组成的字符串，用这个字符串给随机的学生信息name赋值。  
```
def randomGender
  i = (rand(0..1) + 0.5).to_i
  if i == 1
    "male"
  else
    "female"
  end
end
```
这段代码通过产生一个0或1的随机整数来产生对应性别的字符串，然后将这个字符串给随机的学生信息gender赋值。  
学生信息的age属性通过`rand(15..20)`来产生一个在15到20之间的随机数获得。  
将生成的随机学生信息hash形式逐一添加进数组students_hash，最后将students_hash数组存入新创建的yaml文件中。students数组则保存每个student类的实例。  
  
`loadStuInfo`方法用于将已存在的保存有学生信息的yaml文件加载进内存，并打印出信息。  
  
`sortArrayBy`方法用于对保存student类的数组进行排序，两个参数分为别数组、排序依据的属性。`array[0].respond_to?(attr)`检查用于排序的属性是否存在，属性存在则进行排序。`array.sort! {|a,b| a.__send__(attr) <=> b.__send__(attr)}`使数组按照参数attr指定的属性进行排序，__send__方法用于读取attr指定的属性，sort!表明排序将会影响原数组。  

通过`File::exists?("data.yaml")`检查是否存在对应的学生信息的yaml文件，如果存在则调用loadStuInfo方法加载学生信息；如果不存在则调用createStuInfo方法生成随机的学生信息。
