# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

customers = Customer.create([
  {
    address_line_1: "a",
    address_line_2: "b",
    country: "CN",
    locality: "Jiangsu",
    postal_code: "511495",
    email: "mr.bz@hotmail.com",
    first_name: "benson",
    last_name: "zhang",
    note: "im cool",
    phone_number: "01234567890",
  },
  {
    address_line_1: "",
    address_line_2: "",
    country: "US",
    locality: "LA",
    postal_code: "12345",
    email: "sz@gmail.com",
    first_name: "kong",
    last_name: "panda",
    note: "hello",
    phone_number: "01234567890",
  },
  {
    address_line_1: "opop",
    address_line_2: "floor 2",
    country: "US",
    locality: "SF",
    postal_code: "6789",
    email: "sudo@kmail.com",
    first_name: "johnson",
    last_name: "white",
    note: "VIP",
    phone_number: "40040040040",
  },
])
