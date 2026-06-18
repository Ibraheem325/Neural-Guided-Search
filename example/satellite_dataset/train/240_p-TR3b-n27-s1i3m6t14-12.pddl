(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	spectrograph4 - mode
	infrared2 - mode
	image1 - mode
	infrared5 - mode
	thermograph0 - mode
	thermograph3 - mode
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	Star9 - direction
	GroundStation12 - direction
	Star13 - direction
	GroundStation8 - direction
	Star0 - direction
	Star11 - direction
	GroundStation10 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 infrared5)
	(supports instrument0 thermograph0)
	(supports instrument0 spectrograph4)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 GroundStation8)
	(supports instrument1 image1)
	(supports instrument1 thermograph3)
	(supports instrument1 infrared2)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 Star11)
	(calibration_target instrument1 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star9)
)
(:goal (and
	(pointing satellite0 Star7)
	(have_image Planet14 infrared2)
	(have_image Phenomenon15 thermograph0)
	(have_image Phenomenon15 infrared5)
	(have_image Star16 image1)
	(have_image Star16 infrared5)
	(have_image Star17 spectrograph4)
))

)
