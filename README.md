# Theseus

After the [paradox](https://en.wikipedia.org/wiki/Ship_of_Theseus)

```ruby
# Define new models with
Model.add :ClassName
# Then you can call it by that class
ClassName
# You can also define any accessors
# and getter via just calling the named method
ClassName.variable = %w( Accepts anything even an array )
# Then to get the variable just use it
puts ClassName.variable
# Then as a hash
ClassName.to_h
# There is also the reset api at
# https://localhost:3000/ClassName.json
```

