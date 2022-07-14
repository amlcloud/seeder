
// This sudo code explains how transactions look for the entity:
// 
// name: 'John Smith'
// account: 1234234
// bank: 'NAB'
// bsb: '12342'
//

// choose describes the probability of a transaction
// with its first parameter (in this case transaction_type) 
// being the value of its second parameter 
// (in this case 'CREDIT' - 10-20% probability,
//               'DEBIT' - 90-80% probability
// )                  
choose(
  'transaction_type',
  //Probability:
  {
    'CREDIT': 0.1, // 0.1-0.2
    'DEBIT': 0.9, //  0.9-0.8
  },
  {
    'CREDIT': choose(
      'category',
      //EMPLOYED:
      {
        'cash deposit': 0.1,
        'cash deposit third party': 0.1,
        'interest': 0.00001,
        'cheque deposit': 0.00001,
        'direct credit': 0.6, // salary for stable employer people
        'third party transfer': 0.2 // centerlink falls under this.
      },
      //UNEMPLOYED/STUDENT
      // {
      //   'cash deposit': 0.2,
      //   'cash deposit third party': 0.2,
      //   'interest': 0.001,
      //   'cheque deposit': 0.001,
      //   'direct credit': 0.1, // same as 'direct deposit': 0.4,
      //   // if stable employer - salary comes as 'direct credit'
      //   'third party transfer': 0.5  //centerlink falls under this.
      //   // for unemployed could be up to 50% of all income
      //   // also used for casual or one off jobs
      //   // this payments mostly go via NPP, but it will not be visible
      // },

      {
        'cash deposit': {
          // chooseAny picks a random number from an array
          "amount": chooseAny(
            [500, 700, 1000, 1200, 1500, 1800, 2000, 2500]
          ),
          "category": 'cash deposit',
          "reference": chooseAny([
            'Branch, Collins st., Melbourne 3000',
            'Branch, Russel st., Melbourne 3000',
            'Branch, Lonsdale st., Melbourne 3000',
            'ATM, NAB, Melbourne Central, Melbourne 3000', // can use other bank's ATM with your CBA card to cash deposit
            'ATM, NAB, 3 Lonsdale st., Melbourne 3000',
            'Australia Post, 34 Lonsdale st., Melbourne 3000',
          ]),
          "rem_name": 'John Smith', // entity's name or empty
          "rem_account": 1234234, // entity's account
          "rem_bank": 'NAB', // entity's account
          "rem_bsb": '12342', // entity's bank bsb
          "ben_name": 'John Smith', // entity's name
          "ben_account": 1234234, // entity's account
          "ben_bank": 'NAB', // entity's account
          "ben_bsb": '12342', // entity's bank bsb
        },
        'cash deposit third party': {
          "amount": chooseAny([500, 700, 1000, 1200, 1500, 1800, 2000, 2500]),
          "category": 'cash deposit third party',
          "reference": '',
          "rem_name": 'James Webb', // entity's name or empty
          "rem_account": 43543543, // entity's account
          "rem_bank": 'ANZ', // entity's account
          "rem_bsb": '435343', // entity's bank bsb
          "ben_name": 'John Smith', // entity's name
          "ben_account": 1234234, // entity's account
          "ben_bank": 'NAB', // entity's bank
          "ben_bsb": '12342', // entity's bank bsb
        },
        'direct credit': {
          "amount": chooseAny([500, 700, 1000, 1200, 1500, 1800, 2000, 2500]),
          "category": 'direct credit',
          "reference":
            chooseAny([
              'ABC Pty. Ltd., 4233', // - staff number
              'Salary April, 2022, ABC Pty. Ltd.',
              'Salary April, 2022, ABC Pty. Ltd. 43532',
              'DEF Pty. Ltd.', // could be salary or other relationship
              'GHI Pty. Ltd. wages',
              'ATO',
              'Centrelink',
              'Bill Gates', // could be private person, but rare
            ]),
          "rem_name": 'ABC Pty. Ltd.', // entity's employer name
          "rem_account": 43543543, // entity's employer account
          "rem_bank": 'CWB', // entity's employer bank
          "rem_bsb": '434533', // entity's bank bsb
          "ben_name": 'John Smith', // entity's name
          "ben_account": 1234234, // entity's account
          "ben_bank": 'NAB', // entity's bank
          "ben_bsb": '12342', // entity's bank bsb
        },
        'cheque deposit': {
          "amount": chooseAny([500, 700, 1000, 1200, 1500, 1800, 2000, 2500]),
          "category": 'cheque deposit',
          "reference": 'ATM',
          "rem_name": 'James Webb', // random person's name
          "rem_account": 43543543, // random person's account
          "rem_bank": 'CWB', // random person's bank
          "rem_bsb": '434533', // random person's bank bsb
          "ben_name": 'John Smith', // entity's name
          "ben_account": 1234234, // entity's account
          "ben_bank": 'NAB', // entity's bank
          "ben_bsb": '12342', // entity's bank bsb
        },
      }),

      {
    'transaction_type': 'DEBIT',
    ...choose(
      'category',
      {
        'payment': 0.4, // random offline and online
        // 'direct debit': 0.2, // utilities, scheduled, monthly, insurance, 
        // amazon, netflix, apple, spotify, ...
        'cash withdrawal': 0.1,
        'linked account transfer': 0.1,
        'third party transfer': 0.15, //includes BPay, NPP, PayID
        //'loan repayment': 0.0005, // once a month
        'IFT': 0.05,
      },
      {
        'payment': {
          "amount":
            randomAmountWithCents(2, 5999, 100),
          //"category": 'payment',
          ...getRandomPaymentBen(),
          "reference": '',
          ...getSelfRemAccount(customer),
          //...randomPurchaseBenAccount(counterparties),
          ...{
            ben_name: randomName(),
            ben_account: randomAccount(),
            ben_bsb: randomBSB(),
            ben_bank: randomBank(),
            ben_country: 'AU',
          }
        },
        'IFT': {
          "amount": chooseAny(
            [50, 70, 100, 120, 150, 180, 200, 250, 300, 350, 400, 450, 500, 550]
          ),
          //"category": 'IFT',
          "reference": choose(
            'reference',
            {
              'support': 0.9,
              'buy item': 0.1
            }),
          ...getSelfRemAccount(customer),
          ...{
            ben_name: randomName(),
            ben_account: randomAccount(),
            ben_bsb: randomBSB(),
            ben_bank: randomBank(),
            ben_country: 'AU',
          }

        },
        'cash withdrawal': {
          "amount": chooseAny(
            [100, 200, 300, 350, 400, 450, 500, 600, 700, 800, 900, 1000, 1200, 1500, 1800, 2000, 2500]
          ),
          //"category": 'cash withdrawal',
          "reference": chooseAny([
            'ATM', 'Branch'
          ]),
          ...getSelfRemAccount(customer),
          ...getSelfBenAccount(customer),
        },
        'linked account transfer': {
          "amount": chooseAny(
            [50, 70, 100, 120, 150, 180, 200, 250, 300, 350, 400, 450, 500, 550]
          ),
          "category": 'linked account transfer',
          "reference": '',
          ...getSelfRemAccount(customer),
          ...getSelfBenAccount(customer),
        },
        'third party transfer': {
          "amount": randomAmountWithoutCents(5, 5000, 200),
          // 5 (coffee) - $10K (gift/loan from a friend/family)
          // round amount, 473 10000, 5000, 34, 5, 5.50, 75, 200, 300, 400, 150,
          "category": 'third party transfer',
          "reference": chooseAny([
            'loan', 'gift', 'rent', 'bill', 'lunch', 'coffee', 'food',
            'dinner', 'thank you', 'love you',
            'chair', 'bike', 'gumtree', 'facebook market',
          ]),
          ...getSelfRemAccount(customer),
          ...{
            ben_name: randomName(),
            ben_account: randomAccount(),
            ben_bsb: randomBSB(),
            ben_bank: randomBank(),
            ben_country: 'AU',
          }
        },


        // 'loan repayment': {
        //   "amount": chooseAny(
        //     [100, 200, 300, 350, 400, 450, 500, 600, 700, 800, 900, 1000, 1200, 1500, 1800, 2000, 2500]
        //   ),
        //   "category": 'loan repayment',
        //   "reference": 'loan repayment',
        //   ...getSelfRemAccount(customer),
        //   ...getRandomBenAccount(counterparties),
        // }
      })
  };