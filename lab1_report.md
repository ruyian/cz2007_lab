## Lab 1 report

### Assumptions made
1. "shop name" is the key for the shop entity set since all the shops have unique names
2. Maker needs to be recorded for a product. We assume there is only one maker for each product, and design it as an attribute.
3. Each complaint has a unique "complaint id" that can be used to identify complaints.
4. Users are not allowed to make a complaint about product nor give rating of product unless they have made an order. Users are free to make complaints about any shops.
5. One order may contain many products which have different delivery dates
6. Relevant timestamps are recorded upon the completion of the action it refers to

### Discussion outcome

#### How can we store the price history information?

#### Why is ....