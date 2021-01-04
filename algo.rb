# I decided to do these problems in Ruby because it is the programming language that I am most familiar doing algorithms with. 

##SYNC Question

# For this question we want you to synchronize two lists. Each list contains only integers. The goal of the problem is to return the list of integers which are not contained in both lists.

def sync(list1, list2)
    hash_map = Hash.new(0)

    result= []
    list1.each{|ele| hash_map[ele]+=1}
    list2.each do |ele|
        if !hash_map.has_key?(ele)
            result << ele
        else
            hash_map[ele] += 1
        end
    end
    first_list = []
    hash_map.each_key do |k| 
      if hash_map[k] == 1
        first_list << k
      end
    end 
    return first_list + result 
end

p sync([1, 2, 3], [1, 3, 4])
# this will return [2,4]

p sync([1, 2, 3], [1, 2, 3])
# returns an []
## This has a time complexity of O(n) That is because I am only ever iterating through each list one time, and the look up time for a hash is O(1) time. I believe that the space complexity is also O(n)
## though of a greater magnitude unfortunately, because there are several times where I have multi-line codes. I tried to make the first_list portion into a one line problem, but all the other methods
## would return the 1 in the key as a value and return that into the final method. That is why I went through and iterated through the key again. With a bit more research I could make this even smaller. 


def equals(hash1, hash2)
    if hash1.length != hash2.size 
        return false 
    end 
    # This is the easiest base case, where if the two hashes don't have the same length then they obviously cannot be equal. 

    hash1.each_key{|k| return false if !hash2.has_key?(k)}
    # Another simple case check. This is O(n) time check, since hash lookup is o(1) but we are iterating through the first hash. Basically we are making sure that every single key is the same. 
    #If we are at this point then the lengths and keys are the same, and we are in O(n) time and O(2?) space complexity. Now what we have to do is go through and check that the values are the same. 
    hash1.each_key do |k|
        if hash1[k].is_a?(Hash)
            if !check(hash1[k], hash2[k])
                return false
            end
        else
            if hash1[k] != hash2[k]
                return false
            end
        end
    end
    return true 
end

def check(hash1, hash2)
    hash1.each_key do |k|
        if hash2[k] != hash1[k]
            return false
        end
    end
    return true
end

a= {"key1" => "value", "key2" => {"key3"=> 1}}
b = {"key1" => "value", "key2" => {"key3"=> 1}}
c = {"key1" => "value1", "key2" => {"key3"=> 1},"key4" => "value2"}
p(a,b)
p equals(c,b)

#These equal true and false. 
=begin
Unfortunately this is in O(n^2) time. The reson for this is that if we are represented with a hash as a value I wrote a helper function that goes through and checks to make sure that the hash is equal or not. 
This makes it O(n^2) because you are iterating through the keys of the original hash, then you have to do another iteration of the hash that is a value. This adds time complexity. Unfortunately, I think that this 
also makes the space complexity into O(n^2) since you are calling on another algorithm within an algorithm. I think that this is the smallest I could make it, with the time that I have. 
=end