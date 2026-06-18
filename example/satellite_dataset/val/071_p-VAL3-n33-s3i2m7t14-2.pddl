(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	thermograph1 - mode
	spectrograph0 - mode
	image4 - mode
	infrared2 - mode
	infrared3 - mode
	image5 - mode
	spectrograph6 - mode
	Star0 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star7 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation6 - direction
	GroundStation1 - direction
	GroundStation13 - direction
	GroundStation12 - direction
	Star5 - direction
	GroundStation8 - direction
	Star2 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 infrared2)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 GroundStation12)
	(supports instrument1 infrared2)
	(supports instrument1 spectrograph6)
	(supports instrument1 image4)
	(calibration_target instrument1 GroundStation13)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation13)
	(supports instrument2 thermograph1)
	(supports instrument2 spectrograph6)
	(supports instrument2 infrared3)
	(calibration_target instrument2 GroundStation1)
	(supports instrument3 spectrograph0)
	(supports instrument3 infrared3)
	(supports instrument3 spectrograph6)
	(calibration_target instrument3 Star2)
	(calibration_target instrument3 Star5)
	(calibration_target instrument3 GroundStation13)
	(calibration_target instrument3 GroundStation8)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet17)
	(supports instrument4 spectrograph0)
	(supports instrument4 image5)
	(calibration_target instrument4 Star2)
	(calibration_target instrument4 GroundStation8)
	(calibration_target instrument4 Star5)
	(calibration_target instrument4 GroundStation12)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon15)
)
(:goal (and
	(pointing satellite1 Star0)
	(pointing satellite2 GroundStation12)
	(have_image Phenomenon14 image5)
	(have_image Phenomenon14 image4)
	(have_image Phenomenon15 spectrograph0)
	(have_image Phenomenon15 infrared3)
	(have_image Phenomenon16 spectrograph0)
	(have_image Phenomenon16 infrared2)
	(have_image Planet17 spectrograph0)
))

)
