require File.expand_path('../read_data', __FILE__)

class Main
	def initialize(type)
		# type: [:FY, :JP, :JD, :DX]
		case type
		when :FY
			file_path = Config::FY_PATH
			new_file_path = Config::FY_NEW_PATH
		when :JP
			file_path = Config::JP_PATH
			new_file_path = Config::JP_NEW_PATH
		when :JD
			file_path = Config::JD_PATH
			new_file_path = Config::JD_NEW_PATH
		when :DX
			file_path = Config::DX_PATH
			new_file_path = Config::DX_NEW_PATH
		end
		@new_file_path = new_file_path
		@read_data = ReadData.new(file_path)
	end

	def run
		result = @read_data.read_data

		puts '@@@' * 50
		puts result[:mal].length, result[:mat].length

		result[:mat].each do |data|
			n = 0
			new_name = shuffle_generate(data.name)
			while result[:names].include?(new_name)
				n += 1
				puts '***' * 50
				puts "#{data.id}-#{n}"
				new_name = shuffle_generate(new_name)
			end

			result[:names] << new_name
			data.name = new_name

			result[:mal] << data
		end

		puts '###' * 50
		puts result[:mal].length

		CSV.open(@new_file_path, 'wb', encoding: 'gb18030') do |csv|
			if result[:mal].count == 0
				csv << ['无订单数据']
			else
				csv << %w(id[记录ID] name[订单编号])
				result[:mal].each do |record|
					csv << [record.id, record.name]
				end
			end
		end
	end

	private

	def shuffle_generate(num)
		sub_s = num.match(/\A\S{2,4}(-)\d{8}/)[0]
		suc_n = num.sub(sub_s, '')

		shuffle_s = ''
		suc_n.length.times do
			shuffle_s += ('0'..'9').to_a.shuffle[0]
		end

		generate_num = sub_s + shuffle_s

		generate_num
	end
end