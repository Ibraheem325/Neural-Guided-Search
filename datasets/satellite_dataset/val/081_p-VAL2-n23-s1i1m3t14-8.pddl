(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	thermograph1 - mode
	thermograph2 - mode
	Star0 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	Star6 - direction
	Star7 - direction
	GroundStation8 - direction
	Star10 - direction
	GroundStation11 - direction
	GroundStation13 - direction
	GroundStation1 - direction
	GroundStation9 - direction
	Star2 - direction
	GroundStation12 - direction
	Phenomenon14 - direction
	Star15 - direction
	Phenomenon16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 image0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon17)
)
(:goal (and
	(have_image Phenomenon14 image0)
	(have_image Star15 thermograph1)
	(have_image Phenomenon16 image0)
	(have_image Phenomenon17 image0)
))

)
