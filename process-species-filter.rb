#!/usr/bin/ruby
require 'csv'

class ProcessSpeciesFilter

	def initialize(possible_values,example_images)
		@possible_values = possible_values
		@example_images = example_images
		@csvHeader = createOutputCSVHeader(@possible_values)
	end

	def createOutputCSVHeader(possible_values)
		csvHeader= []
		csvHeader.push "Name"
		@possible_values.keys.each do |category|
			@possible_values[category].each do |subcategory|
				image = @example_images[subcategory]
				if image.nil?
					csvHeader.push "#{category}=#{subcategory}"
				else
					csvHeader.push "#{category}=#{subcategory},#{image}" # include example image
				end
			end
		end
		return csvHeader
	end

	def populateFields(field_key,animal,fields)
		@possible_values[field_key].each do |test_value|
			if animal[field_key].to_s.include?(test_value)
				fields["#{field_key}=#{test_value}"] = 'Y'
			else
				fields["#{field_key}=#{test_value}"] = 'N'
			end
		end
	end

	def readCSV(csv_filepath)
		csvOut = CSV.open("output.csv","w")
		csvOut << @csvHeader

		csvIn = CSV.read(csv_filepath, :headers => true)
		csvIn.each do |animal|
			fields = {}
			fields['Name'] = animal['Name']
			@possible_values.keys.each do |animal_property|
				populateFields(animal_property,animal,fields)
			end
			csvOut << fields.values # write completed row to CSV
		end
	end

end

possible_values = {
 'Color'   => ['Tan/Brown','Red','White','Gray/Black'],
 'Antlers' => ['Yes','No'],
 'Pattern' => ['Stripes','Bands','Spots','Solid'],
 'Tail'    => ['Bushy','Smooth','Long','Short'],
 'Build'   => ['Stocky','Tall','Lanky','Small','Low Slung']
}

example_images = {
	'Tan/Brown'  => 'colorTanBrown.svg',
	'Red'        => 'colorRed.svg',
	'White'      => 'colorWhite.svg',
	'Gray/Black' => 'colorGrayBlack.svg',
	'Stripes'    => 'patternStripes.svg',
	'Bands'      => 'patternBands.svg',
	'Spots'      => 'patternSpots.svg',
	'Solid'      => 'patternSolid.svg',
	'Bushy'      => 'patternBushy.svg',
	'Smooth'     => 'patternSmooth.svg',
	'Long'       => 'tailLong.svg',
	'Short'      => 'tailShort.svg',
	'Stocky'     => 'tailStocky.svg',
	'Tall'       => 'buildTall.svg',
	'Lanky'      => 'buildLanky.svg',
	'Small'      => 'buildSmall.svg',
	'Low Slung'  => 'buildLowSlung.svg'
}

speciesFilter = ProcessSpeciesFilter.new(possible_values,example_images)
speciesFilter.readCSV('species-filter.csv')
