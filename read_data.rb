require 'csv'
require File.expand_path('../new_data', __FILE__)
require File.expand_path('../config', __FILE__)

class ReadData
	def initialize(file_path)
		@filepath = file_path
	end

	def read_data
		readed_datas = {}
		format_datas = []
		formal_names = []
		recordtypes =
			[Config::FORMAL_FY_RECORDTYPE, Config::FORMAL_JP_RECORDTYPE, Config::FORMAL_JD_RECORDTYPE,
				Config::FORMAL_DX_RECORDTYPE, Config::FORMAL_FK_RECORDTYPE, Config::FORMAL_SK_RECORDTYPE]

		CSV.foreach(@filepath, headers: true) do |row|
			data = NewData.new()
			data.id = row['id']
			data.name = row['name']
			if recordtypes.include?(row['recordtype'])
				format_datas << data
			else
				formal_names << row['name']
			end
		end

		readed_datas[:mat] = format_datas
		readed_datas[:names] = formal_names
		readed_datas[:aft] = []

		readed_datas

		# puts '###################'
		# puts formal_datas
		# puts '@@@@@@@@@@@@@@@@@@@'
		# puts format_datas
		# puts '*******************'
		# puts formal_names
	end
end