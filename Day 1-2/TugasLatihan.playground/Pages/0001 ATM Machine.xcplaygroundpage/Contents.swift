class ATMMachine {
    static func checkBalance() {
        print("\tYour current balance is \(BalanceInquiry.getBalance())")
    }

    static func withdrawMoney() {
        if BalanceInquiry.getBalance() == 0 {
            print("\tYour current balance is zero.")
            print("\tYou cannot withdraw!")
            print("\tYou need to deposit money first.")
        } else if BalanceInquiry.getBalance() <= 500 {
            print("\tYou do not have sufficient money to withdraw")
            print("\tCheck your balance to see your money in the bank.")
        } else if Withdraw.getWithdraw() > BalanceInquiry.getBalance() {
            print("\tThe amount you withdraw is greater than your balance")
            print("\tPlease check the amount you entered.")
        } else {
            let newBalance = BalanceInquiry.getBalance() - Withdraw.getWithdraw()
            BalanceInquiry.setBalance(b: newBalance)
            print("\n\tYou withdraw the amount of Rp \(Int(Withdraw.getWithdraw()))")
        }
    }

    static func depositMoney() {
        let newBalance = BalanceInquiry.getBalance() + Deposit.getDeposit()
        BalanceInquiry.setBalance(b: newBalance)
        print("\tYou deposited the amount of \(Deposit.getDeposit())")
    }
}

class Deposit: ATMMachine {
    static var deposit: Double = 100_000 // Hardcoded deposit value

    static func getDeposit() -> Double {
        return deposit
    }
}

class Withdraw: ATMMachine {
    static var withdraw: Double = 0 // Hardcoded withdrawal value

    static func getWithdraw() -> Double {
        return withdraw
    }
}

class BalanceInquiry: ATMMachine {
    private static var balance: Double = 1_500_000 // Hardcoded initial balance

    static func setBalance(b: Double) {
        balance = b
    }

    static func getBalance() -> Double {
        return balance
    }
}

ATMMachine.checkBalance()
ATMMachine.withdrawMoney()
ATMMachine.depositMoney()
ATMMachine.checkBalance()

