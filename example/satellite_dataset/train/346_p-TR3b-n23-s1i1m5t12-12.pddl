(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	thermograph0 - mode
	thermograph3 - mode
	spectrograph4 - mode
	image1 - mode
	GroundStation1 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	Star0 - direction
	Planet12 - direction
	Planet13 - direction
	Star14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 thermograph3)
	(supports instrument0 image1)
	(supports instrument0 thermograph0)
	(supports instrument0 spectrograph4)
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star14)
)
(:goal (and
	(have_image Planet12 thermograph0)
	(have_image Planet13 thermograph3)
	(have_image Star14 image1)
	(have_image Phenomenon15 thermograph0)
))

)
