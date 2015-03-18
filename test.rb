require 'matrix'
#This ruby program reads in two files containing a series of numbers per row
#The first row contains a single numbersuch as 12
#This tells the application there will be 12 rows with 2 columns
#The second integer digit of the first row dictates the number of columns


#Get data from command line
first, second = ARGV

#Save command line data argument 1 into an array
if ARGV.empty?
  puts "Missing file, there should be two"
  exit
else
  data1 = []
  begin
    File.open(first) do |file|
      file.lines.each do |line|
        data1 << line.split.map(&:to_i)
      end
    end
  rescue
    puts "File 1 doesnt exist"
    exit
  end

  data2 = []
  begin 
    File.open(second) do |file|
      file.lines.each do |line|
        data2 << line.split.map(&:to_i)
      end
    end
  rescue
    puts "File 2 doesnt exist"
    exit
  end
end

#Method to create matrix
def get_matrix(m1, m2)
  m1_size = m1.size 
  m1_rows = m1[0][0].to_i #get rows by looking at first digit
  m1_cols = (m1[0][0].to_s[-1,1]).to_i #get columns by looking at second digit
  m1.shift #get rid of first row in array
  
  if m1_size-1 != m1.size
    puts "row, and column defintion on line one does not match file in file1"
    exit
  end
 
  #Build matrix for data file 1
  matrix1 = Matrix.build(m1_rows, m1_cols)
  matrix1 = Matrix.rows(m1)

  m2_size = m2.size  #determine array size
  m2_rows = m2[0][0].to_i #get rows by looking at first digit
  m2_cols = (m2[0][0].to_s[-1,1]).to_i #get columns by looking at second digit
  m2.shift #get rid of first row in array

  if m2_size-1 != m2.size
    puts "row, and column defintion on line one does not match file in file2"
    exit
  end

  #Lets build the matrix
  matrix2 = Matrix.build(m2_rows, m2_cols)
  matrix2 = Matrix.rows(m2) 
  
  begin
    puts "Matrix from file 1: #{matrix1}"
    puts "Matrix from file 2: #{matrix2}"
    multmatrix = matrix1 * matrix2.transpose
    puts "m x n matrix: #{multmatrix}"
    File.open('MatrixOutput.txt', 'w') {|file| file.write(multmatrix)}
  rescue
    puts "Sorry dimensions don't match up"
  end
end

#this calls our method to the do the math
get_matrix(data1, data2)
