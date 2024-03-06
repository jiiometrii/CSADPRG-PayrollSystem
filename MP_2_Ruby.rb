=begin
********************
Name: Manlangit, Aila Janelle C.
Language: Ruby
Paradigm(s): Object-oriented programming  
Group Number and Section:  Group 2 - S18
********************
=end

require 'colorize'

def display_computationDay (day, weekPayroll)
    currentDay = weekPayroll[day]
    print("+------------------------------+------------------+\n")
    print("| #{day.upcase.yellow}                                            |\n")
    print("+------------------------------+------------------+\n")
    print("| Daily Rate                   | #{weekPayroll["Daily Rate"]}\n")
    print("+------------------------------+------------------+\n")
    print("| IN Time                      | #{currentDay.instance_variable_get(:@inTime)}\n")
    print("+------------------------------+------------------+\n")
    print("| OUT Time                     | #{currentDay.instance_variable_get(:@outTime)}\n")
    print("+------------------------------+------------------+\n")
    print("| Day Type                     | #{currentDay.instance_variable_get(:@dayType)}\n")
    print("+------------------------------+------------------+\n")
    print("| Hours on NS                  | #{currentDay.instance_variable_get(:@hoursNS)}\n")
    print("+------------------------------+------------------+\n")
    print("| Hours Overtime (Night Shift) | #{currentDay.instance_variable_get(:@hoursOvertime)}(#{currentDay.instance_variable_get(:@nightOvertime)})\n")
    print("+------------------------------+------------------+\n")
    print("| Salary for the day           | #{currentDay.instance_variable_get(:@day_salary)}\n")
    print("+------------------------------+------------------+\n")
end

def computeIncreaseRate(dayType)
    case dayType
        when "Rest Day" then return 1.30
        when "SNWH" then return 1.30
        when "SNWH and Rest Day" then return 1.50
        when "RH" then return 2.00
        when "RH and Rest Day" then return 2.60
        else
            return 1.00
    end
end

def computeOvertimeDayRate(dayType)
    case dayType
        when "Normal Day" then return 1.25
        when "Rest Day" then return 1.69
        when "SNWH" then return 1.69
        when "SNWH and Rest Day" then return 1.95
        when "RH" then return 2.60
        when "RH and Rest Day" then return 3.38
        else
            return 1.00
    end
end

def computeOvertimeNightRate(dayType)
    case dayType
        when "Normal Day" then return 1.375
        when "Rest Day" then return 1.859
        when "SNWH" then return 1.859
        when "SNWH and Rest Day" then return 2.145
        when "RH" then return 2.86
        when "RH and Rest Day" then return 3.718
        else
            return 1.00
    end
end

class ShiftInfo
    def initialize
        @inTime = "0900"
        @outTime = "0900"
        @dayType = "Normal Day"
        @hoursNS = 0
        @hoursOvertime = 0
        @nightOvertime = 0
        @day_salary = 0.00
    end

    def updateInTime(in_time)
        @inTime = in_time
    end
    def updateOutTime(out_time)
        @outTime = out_time
    end
    def updateDayType(day_type)
        @dayType = day_type
    end
    def updateHoursNS(hours_ns)
        @hoursNS = hours_ns
    end
    def updateHoursOvertime(hours_overtime)
        @hoursOvertime = hours_overtime
    end
    def updateNightOvertime(night_overtime)
        @nightOvertime = night_overtime
    end
    def updateSalary(salary)
        @day_salary = salary
    end
end

weeklyPayroll = {
    "Regular Hours" => 8,
    "Daily Rate" => 500.00,
    "defaultInTime" => "0900",
    "defaultOutTime" => "0900",
    "defaultDayType" => "Normal Day",
    "day1" => ShiftInfo.new,
    "day2" => ShiftInfo.new,
    "day3" => ShiftInfo.new,
    "day4" => ShiftInfo.new,
    "day5" => ShiftInfo.new,
    "day6" => ShiftInfo.new,
    "day7" => ShiftInfo.new,
}

def mainMenu
    puts "\nChoose an option:\n1. Compute Payroll\n2. Change Default Configurations\n3. Exit\n"
end

def validate3Input(input)
    inputValue = false
    if input == "1" || input == "2" || input == "3"
        inputValue = true
    else
        puts "\nInvalid Input. Please choose a valid option".red
    end

    return inputValue
end

def validate2Input(input)
    inputValue = false
    if input == "1" || input == "2"
        inputValue = true
    else
        puts "\nInvalid Input. Please choose a valid option".red
    end

    return inputValue
end

def computeHoursWorked(day, weekPayroll)
    currentDay = weekPayroll[day]
    inTime = (currentDay.instance_variable_get(:@inTime)).to_i
    outTime = (currentDay.instance_variable_get(:@outTime)).to_i
    regularHours = weekPayroll["Regular Hours"]

    oT_Hours = 0
    nOT_Hours = 0
    #Compute Hours Worked
    if (outTime < inTime)
        outTime += 2400
    end
    hoursWorked = (outTime - inTime)/100

    if hoursWorked > (regularHours + 1)
        # Calculate overtime hours
        oT_Hours = hoursWorked - (regularHours + 1)

        # Calculate night shift hours if any
        if outTime >= 2200 && outTime <= 2800
            nOT_Hours = (2200 - outTime).abs/100

            if oT_Hours > 0
                oT_Hours -= nOT_Hours
            end
        end
    
        # Update overtime and overtime night shift hours
        currentDay.updateHoursOvertime(oT_Hours)
        currentDay.updateNightOvertime(nOT_Hours)

    #Compute Night Shift Hours
    else
        if outTime >= 2200 && outTime <= 2800
            nS_Hours = (2200 - outTime).abs/100
            currentDay.updateHoursNS(nS_Hours)
        end
    end

    return hoursWorked
end

def printDayRateTable(dayRate, day, weeklyPayroll)
    currentDay = weeklyPayroll[day]
    if currentDay.instance_variable_get(:@dayType) == "Normal Day"
        puts "+------------------------------+------------------+"
        puts "| Daily Rate                   | #{dayRate}"
        puts "+------------------------------+------------------+"
    elsif currentDay.instance_variable_get(:@dayType) == "Rest Day"
        puts "+------------------------------+------------------+"
        puts "| Daily Rate × Rest Day        | #{dayRate}"
        puts "+------------------------------+------------------+"
    elsif currentDay.instance_variable_get(:@dayType) == "SNWH"
        puts "+------------------------------+------------------+"
        puts "| Daily Rate × SNWH            | #{dayRate}"
        puts "+------------------------------+------------------+"
    elsif currentDay.instance_variable_get(:@dayType) == "SNWH and Rest Day"
        puts "+------------------------------+------------------+"
        puts "| Daily Rate × SNWH-Rest Day   | #{dayRate}"
        puts "+------------------------------+------------------+"
    elsif currentDay.instance_variable_get(:@dayType) == "RH"
        puts "+------------------------------+------------------+"
        puts "| Daily Rate × RH              | #{dayRate}"
        puts "+------------------------------+------------------+"
    elsif currentDay.instance_variable_get(:@dayType) == "RH and Rest Day"
        puts "+------------------------------+------------------+"
        puts "| Daily Rate × RH-Rest Day     | #{dayRate}"
        puts "+------------------------------+------------------+"
    end
end

def computeDayPayroll (day, weeklyPayroll)
    currentDay = weeklyPayroll[day]
    dayType = currentDay.instance_variable_get(:@dayType)
    otHours = currentDay.instance_variable_get(:@hoursOvertime)
    nOtHours = currentDay.instance_variable_get(:@nightOvertime)
    nsHours = currentDay.instance_variable_get(:@hoursNS)
    baseRate = weeklyPayroll["Daily Rate"]

    #Compute Day Rate
    if (dayType != "Normal Day") && computeHoursWorked(day, weeklyPayroll) == 0
        dayRate = baseRate
    elsif dayType == "Normal Day" && computeHoursWorked(day, weeklyPayroll) == 0
        dayRate = 0
    else
        dayRate = baseRate * computeIncreaseRate(dayType)
    end
    
    #Compute Overtime Rates
    nsHoursRate = 0
    otHoursRate = 0
    nOtHoursRate = 0
    if nsHours > 0
        nsHoursRate = nsHours * baseRate / 8 * 1.10
        nsHoursRate = nsHoursRate.round(2)
    end
    if otHours > 0
        otHoursRate = otHours * baseRate / 8 * computeOvertimeDayRate(dayType)
        otHoursRate = otHoursRate.round(2)
    end
    if nOtHours > 0
        nOtHoursRate = nOtHours * baseRate / 8 * computeOvertimeNightRate(dayType)
        nOtHoursRate = nOtHoursRate.round(2)
    end

    day_salary = (dayRate + nsHoursRate + otHoursRate + nOtHoursRate).round(2)
    currentDay.updateSalary(day_salary)

    dayRate = baseRate * computeIncreaseRate(dayType)

    #Print Computation
    puts "\n"
    display_computationDay(day, weeklyPayroll)
    puts "\n"
    puts "Computation:"
    printDayRateTable(dayRate, day, weeklyPayroll)
    
    if nsHours > 0
        puts "NS Hours × Hourly Rate".blue
        puts "#{nsHours} × #{baseRate} ÷ 8 × 1.10 = #{nsHoursRate}\n"
    end
    if otHours > 0
        puts "OT Hours × Hourly Rate".blue
        puts "#{otHours} × #{baseRate} ÷ 8 × #{computeOvertimeDayRate(dayType)} = #{otHoursRate}"
    end
    if nOtHours > 0
        puts "NS OT Hours × Hourly Rate".blue
        puts "#{nOtHours} × #{baseRate} ÷ 8 × #{computeOvertimeNightRate(dayType)} = #{nOtHoursRate}"
    end

    if (dayType != "Normal Day") && computeHoursWorked(day, weeklyPayroll) == 0
        puts "Holiday/Rest Day with no hours worked"
        puts "Additional Pay Not Applicable"
    elsif dayType == "Normal Day" && computeHoursWorked(day, weeklyPayroll) == 0
        puts "Normal Day with no hours worked"
        puts "No Salary for the day"
    end

    print "Salary for the day: ".red
    print "#{day_salary}\n"
    puts "===================================================="
    puts "\n\n"
    
end

def configureDefaultValues(weeklyPayroll)
    option = 0
    puts "Current Default Values:".red
    puts "Daily Rate: #{weeklyPayroll["Daily Rate"]}"
    puts "Regular Hours: #{weeklyPayroll["Regular Hours"]}"
    puts "Default IN Time: #{weeklyPayroll["defaultInTime"]}"
    puts "Default OUT Time: #{weeklyPayroll["defaultOutTime"]}"
    puts "Default Day Type: #{weeklyPayroll["defaultDayType"]}"
    until ["1", "2", "3", "4", "5", "6"].include?(option)
        puts "\nChoose an option:"
        puts "[1] Change Daily Rate"
        puts "[2] Change Regular Hours"
        puts "[3] Change Default IN Time"
        puts "[4] Change Default OUT Time"
        puts "[5] Change Default Day Type"
        puts "[6] Exit to Main Menu"
        option = gets.chomp
        if !(["1", "2", "3", "4", "5", "6"].include?(option))
            puts "\nInvalid Input. Please choose a valid option".red
        end
    end
    
    case option
        when "1"
            validInput = false
            while validInput == false
                puts "Enter new Daily Rate: "
                dailyRate = gets.chomp.to_f
                if dailyRate <= 0
                    puts "Invalid Input. Input must be a number and greater than 0".red
                else
                    validInput = true
                end
            end

            weeklyPayroll["Daily Rate"] = dailyRate
            puts "Daily Rate changed to #{dailyRate}"
        when "2"
            puts "Enter new Regular Hours: "
            regularHours = gets.chomp
            weeklyPayroll["Regular Hours"] = regularHours
            puts "Regular Hours changed to #{regularHours}"
        when "3"
            puts "Enter new Default IN Time: "
            inTime = gets.chomp
            weeklyPayroll["defaultInTime"] = inTime
            puts "Default IN Time changed to #{inTime}"
        when "4"
            puts "Enter new Default OUT Time: "
            outTime = gets.chomp
            weeklyPayroll["defaultOutTime"] = outTime
            puts "Default OUT Time changed to #{outTime}"
        when "5"
            puts "Enter new Default Day Type: "
            dayType = gets.chomp
            weeklyPayroll["defaultDayType"] = dayType
            puts "Default Day Type changed to #{dayType}"
        when "6"
            puts "Default Values not changed"
            puts "Exiting..."
    end

    if option != "6"
        puts "\nNew Default Values".red
        puts "Daily Rate: #{weeklyPayroll["Daily Rate"]}"
        puts "Regular Hours: #{weeklyPayroll["Regular Hours"]}"
        puts "Default IN Time: #{weeklyPayroll["defaultInTime"]}"
        puts "Default OUT Time: #{weeklyPayroll["defaultOutTime"]}"
        puts "Default Day Type: #{weeklyPayroll["defaultDayType"]}"
    end
end

def setToDefault(weeklyPayroll)
    dailyRate = weeklyPayroll["Daily Rate"]
    regularHours = weeklyPayroll["Regular Hours"]
    inTime = weeklyPayroll["defaultInTime"]
    outTime = weeklyPayroll["defaultOutTime"]
    dayType = weeklyPayroll["defaultDayType"]

    weeklyPayroll.each do |key, value|
        next if key == "Daily Rate" || key == "Regular Hours" || key == "defaultInTime" || key == "defaultOutTime" || key == "defaultDayType"
        weeklyPayroll[key].updateInTime(inTime)
        weeklyPayroll[key].updateOutTime(outTime)
        weeklyPayroll[key].updateDayType(dayType)
    end
end

def computePayrollProgram (weeklyPayroll)
    #Compute Payroll Loop
    weeklyPayroll.each do |key, value|
        #Skip default values
        next if key == "Daily Rate" || key == "Regular Hours" || key == "defaultInTime" || key == "defaultOutTime" || key == "defaultDayType"

        #Display default computation for the day
        display_computationDay(key, weeklyPayroll)

        #Get user input for the day
        validInput = false
        while validInput == false
            if key == "day7"
                puts "\nChoose an option:\n1. Make Changes\n2. Compute Week Salary\n"
            else
                puts "\nChoose an option:\n1. Make Changes\n2. Next Day\n"
            end
            userInput = gets.chomp
            validInput = validate2Input(userInput)
        end

        while userInput == "1"
            option = "0"
            until ["1", "2", "3", "4"].include?(option)
                puts "\nChoose an option:\n1. Change IN Time\n2. Change OUT Time\n3. Change to Rest Day\n4. Add a Holiday\n"
                option = gets.chomp
                if !(["1", "2", "3", "4"].include?(option))
                    puts "\nInvalid Input. Please choose a valid option".red
                end
            end

            case option
                when "1"
                    puts "Enter IN Time (HHMM): "
                    inTime = gets.chomp
                    weeklyPayroll[key].updateInTime(inTime)
                when "2"
                    puts "Enter OUT Time (HHMM): "
                    outTime = gets.chomp
                    weeklyPayroll[key].updateOutTime(outTime)
                when "3"
                    puts "\nChanged to Rest Day"
                    weeklyPayroll[key].updateDayType("Rest Day")
                when "4"
                    puts "Choose type of Holiday:\n1. Special Non-Working Holiday\n2. Regular Holiday\n"
                    holidayType = gets.chomp
                        
                    case holidayType
                        when "1"
                            if weeklyPayroll[key].instance_variable_get(:@dayType) == "Rest Day"
                                weeklyPayroll[key].updateDayType("SNWH and Rest Day")
                            else
                                weeklyPayroll[key].updateDayType("SNWH")
                            end
                        when "2"
                            if weeklyPayroll[key].instance_variable_get(:@dayType) == "Rest Day"
                                weeklyPayroll[key].updateDayType("RH and Rest Day")
                            else
                                weeklyPayroll[key].updateDayType("RH")
                            end
                        else
                            puts "Invalid Input"
                    end
            end
            puts "New Values:".red
            display_computationDay(key, weeklyPayroll)

            validInput = false
            while validInput == false
                if key == "day7"
                    puts "\nChoose an option:\n1. Make Changes\n2. Compute Week Salary\n"
                else
                    puts "\nChoose an option:\n1. Make Changes\n2. Next Day\n"
                end
                userInput = gets.chomp
                validInput = validate2Input(userInput)
            end
        end
        #Compute Salary for the day
        computeHoursWorked(key, weeklyPayroll)
        computeDayPayroll(key, weeklyPayroll)
    end
    #display weekly salary
    puts "Salary for the Week:".red
    weekSalary = 0
    weeklyPayroll.each do |key, value|
        next if key == "Daily Rate" || key == "Regular Hours" || key == "defaultInTime" || key == "defaultOutTime" || key == "defaultDayType"
        puts "Salary for #{key}: #{weeklyPayroll[key].instance_variable_get(:@day_salary)}"
        weekSalary += weeklyPayroll[key].instance_variable_get(:@day_salary)
    end
    weekSalary = weekSalary.round(2)
    puts "\n"
    puts "Weekly Salary: #{weekSalary}".red
    puts "\n"
end

#MAIN Program

#Initial input
validInput = false
while validInput == false
    mainMenu
    userInput = gets.chomp
    validInput = validate3Input(userInput)
end

while userInput != "3"
    case userInput
        when "1"
            setToDefault(weeklyPayroll)
            computePayrollProgram(weeklyPayroll)
        when "2"
            configureDefaultValues(weeklyPayroll)
    end

    mainMenu
    userInput = gets.chomp
    validInput = validate3Input(userInput)
end
puts "Terminating Program..."

