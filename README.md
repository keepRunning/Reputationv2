# Reputation v2

## A protocol to manage reputation based on multi-party ratings

## Overview

A blockchain based ratings system which closely resembles a real life ratings model with a more balanced power model between a merchant/service-provider and the consumer.

## Terms

- Merchant - A service provider or a seller.
- Customer - A person using a service or a buyer(consumer).
- Reputation Score(number) - A score representing the aggregate ratings of a Merchant or a Customer.
- REP Token(ERC20 token) - A platform token rewarded to both Merchants and Customers on participation.

## Pain points of the current system

1. Platform controlled and susceptible to be influenced.    
    Merchants can buy reputation score or remove comments/ratings hurting business without improving.
    
2. Once a large reputation score is achieved, average to good reputation is maintained for a long time even when all recent ratings are bad. 
    A sudden drop in ratings, will not reflect at all until considerable time.
    
3. There is no incentive to provide a rating.

## Proposal:

1. Create a reputation system with the following features
    1. Reward on providing reviews - In real life, recommendation is a social reward system. For the online system, we reward this behaviour with REP token. Every review(positive or negative) will earn a reward.
    2. Impact of Rating - Each rating needs to impact both parties. A positive rating will benefit both parties while a negative one will harm both. The difference between the current rating of User and the provided rating(or diff) will be relative value. This value will be added/subtracted from the REP tokens of the both parties.
        
        For example, if the current rating of a Merchant is 3
        
        - If user rates it as 4, the delta is 4-3 = 1 . This is positive and will be added to both.
        - If user rates it as 1, then delta is 1-3 = -2. This is negative and will be subtracted from both.
        
        This will not be a deterrent for providing a negative rating due to a genuinely bad experience due to a reconciliation step.
        
    3. Reconciliation:
        1. Rewarding genuine behavior : If a negative trend has been prominently continuing, then when a correction happens, the users who have been provided negative ratings will be rewarded more. 
        2. Punishing bad behaviour: If a user always gives a negative reviews where others have indicated mostly positive reviews, then the user’s score and tokens will be reduced. The user’s negative review impact will also be removed pushing up the merchant’s score.
        3. The Decentralized Autonomous Organization (DAO) controls the thresholds, customizable settings and entire modules. The REP holders will control the DAO as a community.
        

## Reputation Score

This is the final score that will indicate the reputation of the entity. This will be calculated and updated based on ratings. This will change dynamically, rapidly and show a number of sub-reputations to indicate category based ratings. 

Many real-life scenarios will be taken into consideration such as

- Rapid decline - Continuous bad ratings will bring down the overall rating at an accelerated pace.
- Sliding time-frame - only ratings within a sliding window-timeframe will be used.
- Decay rule - All scores will decay slowly. Being active is the only way to keep it boosted. REP tokens will decay with time too.

## Rep Token

This is an ERC20 token that will be rewarded to both merchants and customers based on participation and accurate reviews.

### Usage

For Customers

1. Rep tokens are earned by providing reviews and by transfer from Merchants.
2. Rep tokens can be redeemed similar to reward points at Merchants.
3. Rep tokens can be converted to better your personal Reputation(up to a limit)

For Merchants

1. Rep tokens are earned by customer reviews.
2. Rep tokens can be received from Customers(as offers/good-will).
3. Rep can be used to boost Ratings(up to a limit). This will help new business get visibility.
4. Rep cannot be transferred between merchants. They can only earned from customers.
5. Merchants with huge REP tokens can reward customers to improve loyalty.

## Benefits

1. Unified reputation platform for multiple use-cases.
2. Blockchain use-case with complete transparency.
3. Customers are rewarded with Rep tokens and Reputation.
4. Customer with good Reputation can get better service/rates.
5. Customers can redeem Rep tokens with new and upcoming Merchants.
6. Merchants can get steady and predictable reviews.
7. Merchants can get a more favorable Reputation Score.
8. New Merchants can boost their Reputation Score with Rep token.
9. Established Merchants can giveaway their Rep tokens to loyal customers.
10. Policies can be tweaked by a well-represented DAO.

## The Process

1. The merchant or user can create the first transaction on-chain indicating a real-life transaction. The other party will have to accept it. We can use oracles to track off-chain transactions. 
2. The customer(C) will create a review for the Merchant(M) and vice versa. Both will be tied to the intially created transaction.


1. Reputation calculation -  This will calculate the reputation score of the entity. This will be part of the pluggable DAO controlled contract. By keeping calculations as part of a purely mathematical contract, the DAO can change the parameters and make meaningful upgrades.
2. Reconciliation - This will use trend/curve analysis or other statistical calculations to compare multiple reviews and find the non-matching reviews.
3. REP tokens - This will be rewarded to both parties for every rating provided.

### 



## Contracts

### 1. OrderRecords Contract

Contains the order information between Merchant and Customer.


### 2. ReviewRecords Contract

Contains the reviews/ratings provided by all users. 


### 3. FinalRatings Contract

Contains the calculated ratings. Only allows the approved calculation contract to update values.


### 4. RepToken Contract

ERC20 contract to hold the reputation rewards.

### 5. RatingCalculator Contract

Calculates the ratings for a user and updates the FinalRatings contract

1. CalculationReputation(userId)
    
    This method calculates and updates the score for a userId.
    
    Anyone can call this method for any userIdentifier.
    
    We start with a mapping of number of days/orders average to use
    
    | Order count | Window size | Max window |
    | --- | --- | --- |
    | >1000 / day | 30 day  | 360 days |
    | >100 / day | 60 day  |  |
    | >10/day | 90 day  |  |
    | 1/month | 360 day  |  |
    
    Based on the above table, we get the window size.
    
    We allocate the values v1, v2, v3… to latest window ratings, window prev to v1, window prev to v2.
    
    For eg: For a merchant with over 1000 orders per day, v1 = Avg of latest 30 days. v2 = Avg of days from last 31 to 60 days and so on.
    
    Then we can use a weighted average to get a score. This could be a GP series, but we need to change it so the multipliers will equal to 1. 
    
    We use the max window to limit the counts, recalculate multipliers until they equal 1 and then use a weighted average calculation like below.
    
    Score = 0.5 * v1 + 0.25 * v2 + 0.167 * v3 + 0.125 * v4 … [nb: Sum or multiplier need to be 1]
    
    This would prioritize recent rating and supports the rapid decline scenario.
    
    The score calculated is updated on the FinalRatings Contract.
    

1. Refresh Interval
    
    The CalculateReputation method needs to be called often to update values. As we see, the minimum duration it considers is one day. So, this could be a daily call for high-volume business. As the order volume reduces or for Customer accounts, the score needs to be refreshed only when they actually make a transaction or as often as necessary.
    
    One gaming approach could be to never update the score after a good run. We need to have a map of when a score becomes stale and indicate this as part of the FinalRatings.
    

### 6. ReconciliationCalculator Contract

Calculates if reconciliation is required for a user and creates adjustments to REPToken Contract.

1. Reconciliate(user)
    
    Checks if ratings go down below by a threshold percent and take action by rewarding all customers who rated negatively.
    
    Frequency 
    
    | Transaction Count | Reconciliation Cycle |
    | --- | --- |
    | Over 100 per day | Daily |
    | Over 10 per day | Every 10 days |
    | Everyone else | Monthly |
    
    We use a common frequency map for both Reputation and Reconciliation calculations and possibly do it together.
    
## Governance

OZ Governance contracts backed by RepToken can be used to tweak the various thresholds.

The calculation contracts for ratings and reconciliations can also be updated with a majority vote. 

The data store(ratings) are simple entries that wouldn’t be changed. Only the final ratings can be recalculated.
