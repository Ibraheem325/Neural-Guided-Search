(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	infrared2 - mode
	infrared1 - mode
	thermograph0 - mode
	Star0 - direction
	Star2 - direction
	GroundStation7 - direction
	Star8 - direction
	Star9 - direction
	Star10 - direction
	GroundStation11 - direction
	GroundStation13 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	Star12 - direction
	GroundStation3 - direction
	Star14 - direction
	Star1 - direction
	GroundStation5 - direction
	Planet15 - direction
	Planet16 - direction
	Planet17 - direction
	Planet18 - direction
	Star19 - direction
	Star20 - direction
	Phenomenon21 - direction
	Phenomenon22 - direction
)
(:init
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 GroundStation13)
	(calibration_target instrument0 GroundStation11)
	(supports instrument1 thermograph0)
	(supports instrument1 infrared1)
	(calibration_target instrument1 Star12)
	(calibration_target instrument1 GroundStation6)
	(calibration_target instrument1 GroundStation5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet15)
	(supports instrument2 infrared2)
	(supports instrument2 thermograph0)
	(calibration_target instrument2 Star14)
	(calibration_target instrument2 GroundStation3)
	(calibration_target instrument2 GroundStation5)
	(supports instrument3 infrared2)
	(calibration_target instrument3 GroundStation5)
	(calibration_target instrument3 Star1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star12)
)
(:goal (and
	(have_image Planet15 thermograph0)
	(have_image Planet16 infrared2)
	(have_image Planet17 infrared2)
	(have_image Planet18 infrared1)
	(have_image Star19 infrared1)
	(have_image Star20 thermograph0)
	(have_image Phenomenon21 infrared2)
	(have_image Phenomenon22 infrared2)
))

)
