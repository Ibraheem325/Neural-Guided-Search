(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	infrared1 - mode
	thermograph0 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star8 - direction
	Star9 - direction
	Star10 - direction
	GroundStation11 - direction
	Star12 - direction
	GroundStation5 - direction
	GroundStation7 - direction
	GroundStation6 - direction
	GroundStation4 - direction
	Planet13 - direction
	Planet14 - direction
	Planet15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 infrared1)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 GroundStation5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet14)
)
(:goal (and
	(pointing satellite0 Planet13)
	(have_image Planet13 infrared2)
	(have_image Planet14 infrared1)
	(have_image Planet15 thermograph0)
	(have_image Phenomenon16 infrared1)
))

)
