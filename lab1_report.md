# Lab 1 report

## Assumptions made
1. "*Shop_name*" is the key for the **shop** entity set since all the shops have unique names.
2. The *maker* needs to be recorded for a product. We assume there is only one maker for each product, and design it as an attribute.
3. Each **complaint** has a unique "*complaint id*" that can be used to identify complaints.
4. Users are not allowed to make a complaint about the product nor give a rating of the product unless they have made an order. Users are free to make complaints about any shops.
5. One order may contain many products which have different delivery dates.
6. Relevant timestamps are recorded upon the completion of the action it refers to.
7. An order may consist of different products from different shops. Thus each product in the order may have different status (some shops have delivered while some have not)
8. A user can check the status of the complaints he has made using services backed by this database system.
9. A user makes an order of multiple products at one time instance. All the products in that orders are bought at the same timestamp.
10. Each **feedback** has class has a unique *feedback id* that can be used to identify it.


## Discussion outcome

**Product** has two subclass entity sets, namely **products in shop** and **products on order**. This is because these two share common attributes such as maker, category. However, they are essentially different as **product in shop** has unique attributes like quantity in stock and unique relationship to **price record** whereas **product on order** has unique attributes such as quantity in order, status and a relationship with **order**. Some of our group members propose using just one product entity set, but this alternative method cannot capture the unique attributes of the two subclasses mentioned above and may leave many unpleasant NULL values in implementation.

We choose to make **products in shop** a subclass of **product** and a weak entity set relating to the **shop**. Its key is <*product_name*, *shop_name*>.

We choose to make **products on order** a subclass of **product** and a weak entity set relating to both the **shop** and **order**. Its key is <*product_name*, *shop_name*, *order_id*>. This is because a user may purchase an iPhoneX from shop A and an iPhoneX from shop B in the same order.

**Shop** does not have a generic relationship with the superclass entity set **product**. Instead, it has a fundamentally different relationship with its subclass entity sets. It  ***sells*** a certain **product in shop** within a specific timeframe while it ***supplies*** **product on order** in an order. Thus, we do not create a relationship with the **product** superclass entity set directly. Instead, we design two relationship between **shop** and the two subclass entity sets of **product**.

**Price record** is a weak entity set of **product in shop** because we would like to keep track of all the changes in price and an attribute could not do the intended job. Some of our team members suggest using just an attribute. However, we cannot keep track of the all the changes in price in the history if we make only an attribute.

The **shop** can sell **product in shop** with a start date and an end date as it is of the shop's freedom to putaway and get items off the shelf at any time they want.

Since the users can make complaints about both shops and products, we classify two subclass entity set from the general **complaint** superclass, **complaint about product** and **complaint about shop** respectively, both having unique relationship either to **product on order** or **shop**. This is also for easy tracing of the complaint target.

We decide not to include average rating and number of rating as attributes of **product in shop** as it can be computed.