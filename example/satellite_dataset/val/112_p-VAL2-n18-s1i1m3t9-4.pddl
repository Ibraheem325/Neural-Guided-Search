(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	thermograph0 - mode
	infrared1 - mode
	Star0 - direction
	Star2 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	Star8 - direction
	GroundStation7 - direction
	GroundStation3 - direction
	Star1 - direction
	Phenomenon9 - direction
	Planet10 - direction
	Planet11 - direction
	Star12 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 thermograph0)
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 GroundStation7)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(pointing satellite0 GroundStation4)
	(have_image Phenomenon9 thermograph0)
	(have_image Planet10 infrared2)
	(have_image Planet11 infrared2)
	(have_image Star12 infrared2)
))

)
