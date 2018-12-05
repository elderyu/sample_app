class StaticPagesController < ApplicationController

  def home
    #asdsad
  end

  def help
  end

  def about
  end

  def contact
  end

  def test
    #asdfsa
    def check_palindrome(s1)
      #asd
      if s1 == s1.reverse
        return "Yup, palindrome!"
      else
        return "Not a palindrome."
      end
      #s1 == s1.reverse ? "Yup, palindrome!" : "Not a palindrome."
    end

    arr_char_dcase = ('a'..'z').to_a
    arr_char_ucase = ('A'..'Z').to_a
    arr_num = ('1'..'9').to_a
    arr = arr_char_dcase + arr_num + arr_num + arr_char_ucase
    @code = "Random code is: "
    15.times do
      @code << arr[rand(arr.length-1)]
    end
    @racecar = ("racecar".length).to_s

    #@s = 1 if Range.new(1,9) == (1..9)

    # person1 = {first: "John", last: "Brown"}
    # person2 = {first: "Alan", last: "Black"}
    # person3 = {first: "Judy", last: "Yellow"}
    # params = {father: person1, mother: person2, child: person3}
    # @s = params[:father][:first]

    # params = {name: "Jan", email: "email"}
    # hashohash = {hash: params, cosinnego: "inne"}
    # @s = "asd "
    # spanish = {one: "uno", two: "dos", three: "tres"}
    # spanish.each do |k,v|
    #   @s << "#{k} is in spanish #{v}"
    # end


    # def yeller(arr = ['No', 'Array', 'Given!'])
    #   arr.join.upcase!
    # end
    #
    # @s = yeller(['fdsfeEwr', 'fesfdsj', 'oiujsfcx3'])

    # @s = Array.new
    # (0..16).each do |num|
    #   @s << 2**num
    # end

    #@code = rand(10).to_s
    # @a = "A man, a plan, a canal, Panama".delete(", ").downcase
    # @s = @a
    # @s = check_palindrome(@a)

    # @a = @a.join
    # @a = @a.split(" ")
    # @a = @a.join
    # @s = @a.downcase!
    # @s = check_palindrome(@s)


    # arr_new = Array.new
    # (1..99).each do |num|
    #   @flag = 0
    #   (2..num-1).each do |divider|
    #     @flag = 1 if num % divider == 0
    #   end
    #   arr_new << num if @flag == 0
    #   @s = arr_new
    # end

    #@s = @a.join
    #@s = @a.split(" ")
    #@s = @a.join(" ")
    #@s = check_palindrome(@a)
    #@a.downcase
    #@s = check_palindrome(@a)



    #w = Word1.new
    #@s = Symbol.class.superclass
    # string = "Concatenate"
    # @s = "Concatenate".shuffle


    #@s = string.shuffle[0...string.length]
    user = User.new({first: "Jan", last: "Kowalski", email: "j@k" })
    @s = user.verify

  end

end
#
# class User
# attr_accessor :first, :last, :email
#
#   def initialize(attributes = {})
#     @first = attributes[:first]
#     @last = attributes[:last]
#     @email = attributes[:email]
#   end
#
#   def full_name
#     "#{@first} #{@last}"
#   end
#
#   def formatted_email
#     "#{full_name} <#{@email}>"
#   end
#
#   def alphabetical_name
#     "#{last}, #{first}"
#   end
#
#   def verify
#     full_name.split == alphabetical_name.split(', ').reverse
#   end
#
# end
# class String
#   def palindrom
#     self == reverse
#   end
#   def shuffle
#     split("").shuffle[0..self.length].join
#   end
# end
