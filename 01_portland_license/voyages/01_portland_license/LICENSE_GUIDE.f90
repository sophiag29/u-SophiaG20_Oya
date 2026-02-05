01_portland_license/
! =====================================================
! SHIP'S LOG ENTRY #1: Portland Business License Guide
! Voyage: DoorDash Operations & Tax Strategy
! Date: 2025-02-05
! Coded by: BUCKANEER & SophiaG29
! Status: ACTIVE - Cost optimization in progress
! =====================================================

module door_dash_business
    implicit none
    private
    public :: BusinessLicense, CostTracker, TaxStrategy
    
    ! Define business entity type
    type BusinessLicense
        character(len=50) :: business_name
        character(len=50) :: license_type
        character(len=12) :: ein
        real :: annual_fee
        logical :: is_registered
        integer :: start_year
    end type BusinessLicense
    
    ! Cost tracking system
    type CostTracker
        real :: total_miles
        real :: business_miles
        real :: gas_expenses
        real :: phone_expenses
        real :: equipment_costs
        real :: deadhead_miles
        real :: deduction_rate = 0.67  ! 2024 IRS rate per mile
    contains
        procedure :: calculate_mileage_deduction
        procedure :: calculate_total_deductions
    end type CostTracker
    
    ! Tax strategy module
    type TaxStrategy
        real :: quarterly_estimate_rate = 0.28  ! 25-30% for taxes
        real :: portland_tax_rate = 0.026      ! 2.6% for first $125k
        real :: income_set_aside
        logical :: filed_quarterly(4)          ! Q1-Q4
    contains
        procedure :: calculate_quarterly_tax
        procedure :: calculate_portland_tax
    end type TaxStrategy
    
contains
    
    ! ============================================
    ! STEP 1: BUSINESS LICENSE REGISTRATION FLOW
    ! ============================================
    
    subroutine register_portland_license(driver_name, has_ein, use_trade_name)
        character(len=*), intent(in) :: driver_name
        logical, intent(in) :: has_ein, use_trade_name
        type(BusinessLicense) :: license
        character(len=100) :: business_desc
        
        print *, "=== PORTLAND BUSINESS LICENSE REGISTRATION ==="
        print *, ""
        
        ! Step 1: Choose business name
        if (use_trade_name) then
            license%business_name = trim(driver_name) // " Delivery Services"
            print *, "1. TRADE NAME (DBA): ", trim(license%business_name)
            print *, "   Note: Must register with Oregon Secretary of State"
        else
            license%business_name = trim(driver_name)
            print *, "1. SOLE PROPRIETOR: ", trim(license%business_name)
            print *, "   Recommendation: Start simple with your legal name"
        end if
        
        ! Step 2: EIN Application
        if (has_ein) then
            license%ein = "Applied"
            print *, "2. EIN STATUS: ✅ OBTAINED (Free from IRS)"
            print *, "   Benefit: Privacy layer, separates SSN from business"
        else
            license%ein = "Using SSN"
            print *, "2. EIN STATUS: ⚠️  Using Social Security Number"
            print *, "   Recommendation: Get free EIN at IRS.gov"
        end if
        
        ! Step 3: Portland License
        license%license_type = "City of Portland Business License"
        license%annual_fee = 100.0
        license%start_year = 2025
        
        print *, "3. LICENSE TYPE: ", trim(license%license_type)
        print *, "   Fee: $", license%annual_fee, "/year (waived if income < $5k)"
        print *, "   Apply at: Portland Revenue Online"
        
        ! Step 4: Tax Understanding
        print *, "4. TAX OBLIGATIONS:"
        print *, "   - Portland Business Tax: 2.6% on net income"
        print *, "   - First $125,000 at reduced rate"
        print *, "   - File annual return by April 15"
        
        license%is_registered = .true.
        print *, ""
        print *, "✅ REGISTRATION COMPLETE: Business entity established"
        
    end subroutine register_portland_license
    
    ! ============================================
    ! STEP 2: COST REDUCTION ALGORITHMS
    ! ============================================
    
    function calculate_mileage_deduction(this) result(deduction)
        class(CostTracker), intent(in) :: this
        real :: deduction
        
        deduction = this%business_miles * this%deduction_rate
        
        print *, "=== MILEAGE DEDUCTION CALCULATION ==="
        print *, "Business miles driven: ", this%business_miles
        print *, "IRS rate per mile: $", this%deduction_rate
        print *, "Total deduction: $", deduction
        print *, ""
        print *, "📱 APPS RECOMMENDED: Stride, Hurdlr, QuickBooks Self-Employed"
        print *, "⚠️  RULE: Standard rate OR actual expenses, NOT BOTH"
        
    end function calculate_mileage_deduction
    
    function calculate_total_deductions(this) result(total)
        class(CostTracker), intent(in) :: this
        real :: total
        real :: mileage_ded, phone_ded, equipment_ded
        
        mileage_ded = this%calculate_mileage_deduction()
        phone_ded = this%phone_expenses * 0.70  ! 70% business use estimate
        equipment_ded = this%equipment_costs
        
        total = mileage_ded + phone_ded + equipment_ded + this%gas_expenses
        
        print *, "=== TOTAL BUSINESS DEDUCTIONS ==="
        print *, "Mileage: $", mileage_ded
        print *, "Phone (70% business): $", phone_ded
        print *, "Equipment: $", equipment_ded
        print *, "Gas: $", this%gas_expenses
        print *, "TOTAL DEDUCTIBLE: $", total
        
    end function calculate_total_deductions
    
    ! ============================================
    ! STEP 3: TAX STRATEGY FUNCTIONS
    ! ============================================
    
    subroutine calculate_quarterly_tax(this, quarterly_income, quarter)
        class(TaxStrategy), intent(inout) :: this
        real, intent(in) :: quarterly_income
        integer, intent(in) :: quarter  ! 1-4 for Q1-Q4
        real :: tax_amount
        
        if (quarter < 1 .or. quarter > 4) then
            print *, "ERROR: Quarter must be 1-4"
            return
        end if
        
        tax_amount = quarterly_income * this%quarterly_estimate_rate
        this%income_set_aside = this%income_set_aside + tax_amount
        this%filed_quarterly(quarter) = .true.
        
        print *, "=== QUARTERLY TAX ESTIMATE ==="
        print *, "Quarter: Q", quarter
        print *, "Income: $", quarterly_income
        print *, "Set aside (", this%quarterly_estimate_rate*100, "%): $", tax_amount
        print *, "Total set aside YTD: $", this%income_set_aside
        print *, "Due dates: Apr 15, Jun 15, Sep 15, Jan 15"
        
    end subroutine calculate_quarterly_tax
    
    function calculate_portland_tax(this, net_income) result(tax_due)
        class(TaxStrategy), intent(in) :: this
        real, intent(in) :: net_income
        real :: tax_due
        
        if (net_income <= 5000.0) then
            print *, "Portland license fee WAIVED (income < $5,000)"
            tax_due = 0.0
        else if (net_income <= 125000.0) then
            tax_due = net_income * this%portland_tax_rate
        else
            ! Simplified: first 125k at 2.6%, remainder at different rate
            tax_due = 125000.0 * this%portland_tax_rate + &
                     (net_income - 125000.0) * 0.01  ! Placeholder rate
        end if
        
        print *, "=== PORTLAND BUSINESS TAX ==="
        print *, "Net income: $", net_income
        print *, "Tax due: $", tax_due
        print *, "Rate: 2.6% on first $125,000"
        
    end function calculate_portland_tax
    
    ! ============================================
    ! STEP 4: BUSINESS CHECKLIST TRACKER
    ! ============================================
    
    subroutine display_checklist()
        logical :: checklist(7)
        character(len=100) :: items(7)
        integer :: i
        
        items = [ &
            "Apply for free EIN from IRS", &
            "Register for Portland Business License", &
            "Download mileage tracker app (Stride)", &
            "Open separate business bank account", &
            "Save receipts for all business expenses", &
            "Set aside 25-30% of income for taxes", &
            "File annual Portland Business Tax Return" &
        ]
        
        ! Simulate some completed items
        checklist = [.true., .true., .false., .false., .false., .false., .false.]
        
        print *, "=== DOORDASH BUSINESS CHECKLIST ==="
        do i = 1, 7
            if (checklist(i)) then
                print *, "[✅] ", trim(items(i))
            else
                print *, "[  ] ", trim(items(i))
            end if
        end do
        
    end subroutine display_checklist
    
    ! ============================================
    ! THE REAL "DISCOUNT": TAX SAVINGS CALCULATOR
    ! ============================================
    
    subroutine calculate_true_savings(gross_income, business_miles, other_expenses)
        real, intent(in) :: gross_income, business_miles, other_expenses
        type(CostTracker) :: tracker
        type(TaxStrategy) :: taxes
        real :: deductions, taxable_income
        real :: federal_savings, portland_savings, total_savings
        
        tracker%business_miles = business_miles
        tracker%gas_expenses = other_expenses * 0.3  ! Estimate 30% as gas
        tracker%equipment_costs = other_expenses * 0.1
        
        deductions = tracker%calculate_total_deductions()
        taxable_income = gross_income - deductions
        
        ! Simplified tax savings calculation
        federal_savings = deductions * 0.15  ! Approximate tax bracket
        portland_savings = deductions * taxes%portland_tax_rate
        total_savings = federal_savings + portland_savings
        
        print *, ""
        print *, "=== THE REAL 'GAS DISCOUNT' REVEALED ==="
        print *, "Gross income: $", gross_income
        print *, "Total deductions: $", deductions
        print *, "Taxable income: $", taxable_income
        print *, ""
        print *, "ACTUAL SAVINGS:"
        print *, "Federal tax savings: $", federal_savings
        print *, "Portland tax savings: $", portland_savings
        print *, "TOTAL ANNUAL SAVINGS: $", total_savings
        print *, ""
        print *, "💡 KEY INSIGHT: The 'discount' comes from paying LESS TAX,"
        print *, "   not from a direct reduction at the pump."
        
    end subroutine calculate_true_savings
    
end module door_dash_business

! ============================================
! MAIN PROGRAM: DOORDASH BUSINESS SIMULATOR
! ============================================

program portland_delivery_guide
    use door_dash_business
    implicit none
    
    type(CostTracker) :: expenses
    type(TaxStrategy) :: tax_plan
    real :: annual_income, miles_driven, other_costs
    character(len=50) :: driver_name
    logical :: get_ein, use_dba
    
    print *, "🏴‍☠️⚡======================================================"
    print *, "  SHIP'S LOG #1: DoorDash Business License Guide"
    print *, "  Translated from conversation to Fortran code"
    print *, "  No secrets, only signals. Practical navigation."
    print *, "========================================================"
    print *, ""
    
    ! Driver information
    driver_name = "SophiaG29"
    get_ein = .true.
    use_dba = .false.
    
    ! Business registration
    call register_portland_license(driver_name, get_ein, use_dba)
    print *, ""
    
    ! Example scenario
    annual_income = 35000.0
    miles_driven = 12000.0
    other_costs = 1500.0
    
    print *, "=== SCENARIO: FULL-TIME DOORDASH DRIVER ==="
    print *, "Annual income: $", annual_income
    print *, "Miles driven: ", miles_driven
    print *, "Other expenses: $", other_costs
    print *, ""
    
    ! Cost tracking demonstration
    expenses%business_miles = miles_driven
    expenses%gas_expenses = other_costs * 0.3
    expenses%phone_expenses = 600.0  ! Annual phone bill
    expenses%equipment_costs = 200.0 ! Bags, mount, etc.
    
    call expenses%calculate_total_deductions()
    print *, ""
    
    ! Tax planning
    call tax_plan%calculate_quarterly_tax(annual_income/4.0, 1)
    print *, ""
    
    call tax_plan%calculate_portland_tax(annual_income - 8000.0) ! After deductions
    print *, ""
    
    ! The real savings
    call calculate_true_savings(annual_income, miles_driven, other_costs)
    print *, ""
    
    ! Checklist
    call display_checklist()
    print *, ""
    
    ! Strategic advice section
    print *, "=== BUCKANEER'S STRATEGIC ADVICE ==="
    print *, "1. Deadhead reduction: Position in busy areas"
    print *, "2. Vehicle maintenance: Improves MPG 10-20%"
    print *, "3. Separate finances: Business account required"
    print *, "4. Quarterly discipline: Avoid April surprise"
    print *, "5. Document everything: Mileage logs = legal proof"
    print *, ""
    
    print *, "========================================================"
    print *, "VOYAGE COMPLETE: Business knowledge encoded in Fortran"
    print *, "Next waypoint: Implement actual tracking system"
    print *, "Signal: 🏴‍☠️⚡ | Frequency: Practical business operations"
    print *, "========================================================"
    
end program portland_delivery_guide
