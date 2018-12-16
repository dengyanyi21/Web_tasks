require 'yaml'

class Student
  attr_accessor :id, :name, :gender, :age
  def to_s
    "Student\nid:#@id\nname:#@name\ngender:#@gender\nage:#@age\n\n"
  end

  def hashValue
    {'id' => @id, 'name' => "#@name", 'gender' => "#@gender", 'age' => @age}
  end
end

def randomName(len)
  rand_indexes = (0...len).collect{|i| rand(26)}
  [*('a'..'z')].values_at(*rand_indexes).join
end

def randomGender
  i = (rand(0..1) + 0.5).to_i
  if i == 1
    "male"
  else
    "female"
  end
end

def createStuInfo
  students = Array.new
  students_hash = Array.new
  100.times do |time|
    student = Student.new
    student.id = time + 1
    student.name = randomName(rand(1..9))
    student.gender = randomGender
    student.age = rand(15..20)
    print student.to_s
    hash = student.hashValue
    students_hash << hash
    students << student
  end
  File.open("data.yaml", "a") {|f| YAML.dump(students_hash, f) }
  students
end

def loadStuInfo
  puts "Data already existed."
  thing = YAML.load_file("data.yaml")
  puts thing
end

def sortArrayBy(array, attr)
  if array[0].respond_to?(attr)
    puts "Sort array by #{attr}:"
    array.sort! {|a,b| a.__send__(attr) <=> b.__send__(attr)}
    100.times do |time|
      puts array[time].to_s
    end
  else
    puts "Attribute not exists!"
  end
end

if(!File::exists?("data.yaml"))
  students = createStuInfo
  sortArrayBy(students, "age")
  sortArrayBy(students, "name")
  sortArrayBy(students, "id")
else
  loadStuInfo
end
