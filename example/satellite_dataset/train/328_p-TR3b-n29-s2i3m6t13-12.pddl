(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	thermograph0 - mode
	spectrograph4 - mode
	infrared2 - mode
	infrared5 - mode
	image1 - mode
	thermograph3 - mode
	Star2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star7 - direction
	GroundStation8 - direction
	Star9 - direction
	GroundStation10 - direction
	GroundStation12 - direction
	Star0 - direction
	Star1 - direction
	Star11 - direction
	Star6 - direction
	Star13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Star16 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 thermograph3)
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
	(supports instrument1 thermograph0)
	(supports instrument1 infrared2)
	(supports instrument1 infrared5)
	(supports instrument1 spectrograph4)
	(calibration_target instrument1 Star6)
	(calibration_target instrument1 Star11)
	(calibration_target instrument1 Star1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star6)
)
(:goal (and
	(have_image Star13 thermograph0)
	(have_image Star13 infrared5)
	(have_image Phenomenon14 image1)
	(have_image Phenomenon15 infrared2)
	(have_image Phenomenon15 infrared5)
	(have_image Star16 infrared2)
))

)
