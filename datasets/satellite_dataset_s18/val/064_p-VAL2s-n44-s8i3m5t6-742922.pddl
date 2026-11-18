(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	instrument4 - instrument
	satellite2 - satellite
	instrument5 - instrument
	instrument6 - instrument
	satellite3 - satellite
	instrument7 - instrument
	satellite4 - satellite
	instrument8 - instrument
	instrument9 - instrument
	satellite5 - satellite
	instrument10 - instrument
	instrument11 - instrument
	instrument12 - instrument
	satellite6 - satellite
	instrument13 - instrument
	instrument14 - instrument
	instrument15 - instrument
	satellite7 - satellite
	instrument16 - instrument
	instrument17 - instrument
	spectrograph1 - mode
	infrared0 - mode
	image3 - mode
	infrared4 - mode
	image2 - mode
	Star0 - direction
	GroundStation5 - direction
	GroundStation3 - direction
	GroundStation1 - direction
	Star4 - direction
	Star2 - direction
	Phenomenon6 - direction
	Phenomenon7 - direction
	Star8 - direction
	Phenomenon9 - direction
	Star10 - direction
	Phenomenon11 - direction
	Star12 - direction
)
(:init
	(supports instrument0 infrared4)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star0)
	(supports instrument1 image3)
	(supports instrument1 infrared0)
	(supports instrument1 infrared4)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 GroundStation1)
	(supports instrument2 image2)
	(supports instrument2 infrared4)
	(supports instrument2 infrared0)
	(calibration_target instrument2 Star2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon7)
	(supports instrument3 image2)
	(supports instrument3 spectrograph1)
	(calibration_target instrument3 Star0)
	(supports instrument4 infrared0)
	(supports instrument4 image3)
	(calibration_target instrument4 Star0)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon6)
	(supports instrument5 spectrograph1)
	(supports instrument5 image3)
	(calibration_target instrument5 Star2)
	(calibration_target instrument5 GroundStation1)
	(supports instrument6 spectrograph1)
	(supports instrument6 image2)
	(calibration_target instrument6 GroundStation5)
	(calibration_target instrument6 Star4)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon9)
	(supports instrument7 spectrograph1)
	(supports instrument7 image3)
	(calibration_target instrument7 GroundStation3)
	(on_board instrument7 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star8)
	(supports instrument8 image2)
	(supports instrument8 spectrograph1)
	(calibration_target instrument8 Star2)
	(supports instrument9 spectrograph1)
	(supports instrument9 image3)
	(supports instrument9 image2)
	(calibration_target instrument9 Star4)
	(on_board instrument8 satellite4)
	(on_board instrument9 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star2)
	(supports instrument10 image3)
	(supports instrument10 spectrograph1)
	(calibration_target instrument10 Star4)
	(supports instrument11 image2)
	(supports instrument11 infrared0)
	(calibration_target instrument11 Star4)
	(supports instrument12 infrared0)
	(supports instrument12 infrared4)
	(supports instrument12 spectrograph1)
	(calibration_target instrument12 Star4)
	(calibration_target instrument12 GroundStation3)
	(on_board instrument10 satellite5)
	(on_board instrument11 satellite5)
	(on_board instrument12 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Star10)
	(supports instrument13 infrared4)
	(calibration_target instrument13 Star2)
	(calibration_target instrument13 GroundStation5)
	(supports instrument14 infrared4)
	(supports instrument14 image3)
	(calibration_target instrument14 GroundStation1)
	(calibration_target instrument14 GroundStation3)
	(supports instrument15 infrared0)
	(calibration_target instrument15 Star4)
	(on_board instrument13 satellite6)
	(on_board instrument14 satellite6)
	(on_board instrument15 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Star4)
	(supports instrument16 image2)
	(calibration_target instrument16 GroundStation1)
	(supports instrument17 infrared4)
	(supports instrument17 image2)
	(supports instrument17 image3)
	(calibration_target instrument17 Star2)
	(calibration_target instrument17 Star4)
	(on_board instrument16 satellite7)
	(on_board instrument17 satellite7)
	(power_avail satellite7)
	(pointing satellite7 Star0)
)
(:goal (and
	(pointing satellite1 Star12)
	(pointing satellite2 Phenomenon6)
	(pointing satellite4 Star4)
	(pointing satellite7 Phenomenon11)
	(have_image Phenomenon6 infrared4)
	(have_image Phenomenon7 infrared4)
	(have_image Star8 image3)
	(have_image Phenomenon9 image3)
	(have_image Star10 infrared0)
	(have_image Phenomenon11 image3)
	(have_image Star12 infrared4)
))

)
