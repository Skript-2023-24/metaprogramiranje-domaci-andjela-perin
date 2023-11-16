require "google_drive"

class Table
    include Enumerable
    attr_accessor :t, :ws

    def initialize
        @session = GoogleDrive::Session.from_config("config.json")
        @ws = @session.spreadsheet_by_key("1eR778itd4tqzb6gXqERaueJ9Krg_WCoZDk7lr3LcqyU").worksheets[0]
        @t = find_table(@ws)

    end

    def to_s
        "(#@t)"
    end

    def find_table(ws)

        table_values = []
    
        pocetnoRow = 0
        pocetnoCol = 0
        pronadjenPocetak = false
    
        (1..ws.num_rows).each do |row|
            row_values = []
            (1..ws.num_cols).each do |col|
                cell_value = ws[row, col]
                if !cell_value.empty?
                    pocetnoRow = row
                    pocetnoCol = col
                    pronadjenPocetak = true
                    break
                end
            end
            break unless !pronadjenPocetak
        end
            
        (pocetnoRow..ws.num_rows).each do |row|
            row_values = []
            (pocetnoCol..ws.num_cols).each do |col|
                cell_value = ws[row, col]
                row_values << cell_value
            end
            table_values << row_values 
        end
    
        table_values
    end

    def row(i)
        t[i]
    end

    def each
      if block_given?
        t.each do |row|
          row.each do |cell|
            yield cell
          end
        end
        return
      end
    end

    def [](value)
        index_kolone=0
        postoji_kolona=false
        #prolazimo kroz prvi red tabele
        t[0].each_with_index do |cell, index|
            if cell==value
                index_kolone=index
                postoji_kolona=true
            end
        end
        return t.map { |red| red[index_kolone] } unless !postoji_kolona
    end


    def method_missing(naziv_kolone, *args)
        value1 = naziv_kolone.to_s.split(/(?=[A-Z])/).join(" ")
        value = value1[0].upcase + value1[1..-1]
        index_kolone=0
        postoji_kolona=false
        #prolazimo kroz prvi red tabele
        t[0].each_with_index do |cell, index|
            if cell==value
                index_kolone=index
                postoji_kolona=true
            end
        end
        return t.map { |red| red[index_kolone] } unless !postoji_kolona
    end


end

table = Table.new
p table.t
# p table.row(2)
# p table["Prva Kolona"]
# p table["Treca Kolona"][3]
# p table.trecaKolona
# p table.prvaKolona.map {|x| x=x.to_i + 1}
# p table.prvaKolona.select { |x| x.to_i.odd?}